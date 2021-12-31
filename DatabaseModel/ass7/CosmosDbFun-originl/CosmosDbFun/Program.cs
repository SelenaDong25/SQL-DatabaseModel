using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Configuration;
using System;
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
                        ClassId = Guid.NewGuid().ToString()
                    };
                    
                    await cosmosDbStore.CreateStudentClassRecord(studentClassData);

                    // upsert new student record with specified Id and ClassId. 
                    await cosmosDbStore.UpsertStudent("11111", "Finished");

                    // delete student record with specified Id and ClassId. 
                    await cosmosDbStore.DeleteStudent("88888", "Finished");

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
