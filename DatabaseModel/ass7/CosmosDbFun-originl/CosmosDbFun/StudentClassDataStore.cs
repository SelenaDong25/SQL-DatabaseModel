using Microsoft.Azure.Cosmos;
using System;
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

        public async Task<StudentClassRecord> CreateStudentClassRecord(StudentClassRecord studentClassRecord)
        {
            if (studentClassRecord == null) throw new ArgumentNullException(nameof(studentClassRecord));

            Console.WriteLine($"Creatung Student {studentClassRecord.Id} for Class {studentClassRecord.ClassId}");
            return await container.CreateItemAsync(studentClassRecord);
        }

        public async Task<StudentClassRecord> GetStudentRecord(String studentId, String classId)
        {
            if (studentId == null || classId == null) throw new ArgumentNullException("The student does not exist"!);

            Console.WriteLine($"Get Student {studentId} for Class {classId}");
            return await this.container.ReadItemAsync<StudentClassRecord>(studentId, new PartitionKey(classId));
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

        /*
        public async Task<StudentClassRecord> UpdateStudent(String studentId, String classId)
        {
            StudentClassRecord newRecord = new StudentClassRecord()
            {
                Id = Guid.NewGuid().ToString(),
                ClassId = Guid.NewGuid().ToString()
            };
            var student = GetStudentRecord(studentId, classId);
            student = newRecord;

            ItemResponse item = await this.container.ReplaceItemAsync<StudentClassRecord>(newRecord, newRecord.Id, new PartitionKey(newRecord.ClassId));
            newRecord.Id = studentId;
            newRecord.ClassId = classId;
            Console.WriteLine($"Upserted Student {newRecord.Id} for Class {newRecord.ClassId}");
            return await this.container.UpsertItemAsync<StudentClassRecord>(item: newRecord);
        }
    */
        public async Task DeleteStudent(String studentId, String classId)
        {
             
            if (studentId == null || classId == null) throw new ArgumentNullException("No such record");

            var partitionKey = new PartitionKey(classId);
            Console.WriteLine($"Deleting Student {studentId} for Class {classId}");
           
            ItemResponse<StudentClassRecord> item = await this.container.DeleteItemAsync<StudentClassRecord>(studentId, partitionKey);   
        }
    }
}
