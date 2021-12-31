using Microsoft.Azure.Cosmos;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CosmosDbFun
{
    public class StudentClassDataStore
    {
        private Container container;

        public StudentClassDataStore(Container container)
        {
            this.container = container;
        }

        // Create random new student record
        public async Task<StudentClassRecord> CreateStudentClassRecord(StudentClassRecord studentClassRecord)
        {
            if (studentClassRecord == null) throw new ArgumentNullException(nameof(studentClassRecord));

            Console.WriteLine($"Creatung Student {studentClassRecord.Id} for Class {studentClassRecord.ClassId}");
            return await container.CreateItemAsync(studentClassRecord);
        }

        // Read student record
        public async Task<StudentClassRecord> GetStudentClassRecord(string studentId, string classId)
        {
            if (string.IsNullOrEmpty(studentId)) throw new ArgumentNullException(nameof(studentId));
            if (string.IsNullOrEmpty(classId)) throw new ArgumentNullException(nameof(classId));

            Console.WriteLine($"Reading Student {studentId} for Class {classId}");
            return await container.ReadItemAsync<StudentClassRecord>(studentId, new PartitionKey(classId));
        }

        // Query student record
        public async Task<List<StudentClassRecord>> GetStudents(string classId)
        {
            if (string.IsNullOrEmpty(classId)) throw new ArgumentNullException(nameof(classId));

            QueryDefinition queryDefinition = new QueryDefinition("SELECT * from c where c.ClassId = @classId")
                .WithParameter("@classId", classId);

            List<StudentClassRecord> students = new List<StudentClassRecord>();

            using (FeedIterator<StudentClassRecord> feedIterator = container.GetItemQueryIterator<StudentClassRecord>(
                queryDefinition,
                    null,
                    new QueryRequestOptions() { PartitionKey = new PartitionKey(classId) }))
            {
                while (feedIterator.HasMoreResults)
                {
                    var feedIteratorData = await feedIterator.ReadNextAsync();
                    foreach (var item in feedIteratorData)
                    {
                        students.Add(item);
                       // Console.WriteLine(item.Id);
                    }
                }
            }
            return students;
        }



        // Upsert Student Record
        public async Task<StudentClassRecord> UpsertStudent(String studentId, String classId)
        {
            StudentClassRecord upserting = new StudentClassRecord();
            if (studentId == upserting.Id && classId == upserting.ClassId) throw new ArgumentNullException("Duplicated record cannot be inserted!");

            upserting.Id = studentId;
            upserting.ClassId = classId;
            Console.WriteLine($"Upserted Student {upserting.Id} for Class {upserting.ClassId}");
            return await this.container.UpsertItemAsync<StudentClassRecord>(item: upserting);
        }

        // Update student record
        public async Task<StudentClassRecord> UpdateStudent(String studentId, String classId)
        {
            StudentClassRecord student = await this.GetStudentClassRecord(studentId, classId);
            student.Assignments = new System.Collections.Generic.List<Assignment>
                            {
                                new Assignment()
                                {
                                    Id = Guid.NewGuid(),
                                    Grade = 55,
                                    IsLate = true
                                }
                            };
            Console.WriteLine($"Updated Student {studentId} for Class {classId}");
            return await this.container.ReplaceItemAsync<StudentClassRecord>(student, student.Id, new PartitionKey(student.ClassId));
         
        }
        
        // Delete student record
        public async Task DeleteStudent(String studentId, String classId)
        {

            if (studentId == null || classId == null) throw new ArgumentNullException("No such record");

            var partitionKey = new PartitionKey(classId);
            Console.WriteLine($"Deleting Student {studentId} for Class {classId}");

            ItemResponse<StudentClassRecord> item = await this.container.DeleteItemAsync<StudentClassRecord>(studentId, partitionKey);
        }

        // Print reult
        public void PrintStudent(StudentClassRecord studentRecord)
        {
            string json = JsonConvert.SerializeObject(studentRecord, Formatting.Indented);
            Console.WriteLine($"Result {json}");


        }
    }


}

