using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CosmosDbFun
{
    namespace todo
    {
        public class Program
        {
            public static async Task Main(string[] args)
            {
                var config = CreateConfig();

                try
                {
                    Console.WriteLine("Beginning operations...\n");
                    var container = GetContainer(config);

                    var cosmosDbStore = new StudentClassDataStore(container);

                    var studentClassData = new StudentClassRecord()
                    {
                        Id = Guid.NewGuid().ToString(),
                        ClassId = Guid.NewGuid().ToString(),
                        Assignments = new System.Collections.Generic.List<Assignment>
                            {
                                new Assignment()
                                {
                                    Id = Guid.NewGuid(),
                                    Grade = 45,
                                    IsLate = true
                                }
                            }

                    };

                    // Create new student record with random Id and ClassId.
                    await cosmosDbStore.CreateStudentClassRecord(studentClassData);
                    
                    // upsert 5 new student record with specified Id and ClassId. 
                    string[] studentid = { "11111", "33333", "77777", "aaaaa", "bbbbb" };
                    for (int i = 0; i < 3; i++)
                        await cosmosDbStore.UpsertStudent(studentid[i], "CSD438");
                    for (int i = 3; i < studentid.Length; i++)
                        await cosmosDbStore.UpsertStudent(studentid[i], "CSD331");
                    
                    // Query all students in the same class
                    List<StudentClassRecord> students = await cosmosDbStore.GetStudents("CSD438");
                    foreach(StudentClassRecord item in students) {
                        cosmosDbStore.PrintStudent(item);
                    }

                    // upsert student record with specified Id and ClassId. 
                    var upsertStudent = await cosmosDbStore.UpsertStudent("11111", "Finished");
                    cosmosDbStore.PrintStudent(upsertStudent);

                    // Get student record
                    var readStudent = await cosmosDbStore.GetStudentClassRecord("11111", "Finished");
                    cosmosDbStore.PrintStudent(readStudent);

                    // update student record 
                    var updateStudent = await cosmosDbStore.UpdateStudent("11111", "Finished");
                    cosmosDbStore.PrintStudent(updateStudent);

                    // delete student record with specified Id and ClassId. 
                    await cosmosDbStore.DeleteStudent("11111", "Finished");  

               }
                catch (CosmosException de)
                {
                    Exception baseException = de.GetBaseException();
                    Console.WriteLine("{0} error occurred: {1}", de.StatusCode, de);
                }
                catch (Exception e)
                {
                    Console.WriteLine("Error: {0}", e);
                }
                finally
                {
                    Console.WriteLine("All done!\nPress any key to exit.");
                    Console.ReadKey();
                }
            }

            /// <summary>
            /// Builds key/value based configuration settings for use in an application.
            /// </summary>
            /// <returns></returns>
            private static IConfiguration CreateConfig()
            {
                return new ConfigurationBuilder()
                .AddJsonFile($"appsettings.json", optional: false)
                .Build();
            }

            /// <summary>
            /// Created Container reference to the cosmosDb Container
            /// </summary>
            /// <returns></returns>
            private static Container GetContainer(IConfiguration config)
            {
                Console.WriteLine("Gettind cosmosDB account...\n");
                var cosmosDb = new CosmosClient(config["CosmosDB:ConnectionString"]);

                Console.WriteLine("Gettind database...\n");
                var dataBase = cosmosDb.GetDatabase(config["CosmosDB:DatabaseName"]);

                Console.WriteLine("Gettind container...\n");
                return dataBase.GetContainer(config["CosmosDB:Container"]);
            }
        }
    }
}
