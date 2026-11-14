using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

namespace RaceDay.API.Services
{
    public interface IBlobService
    {
        Task<string> UploadFileAsync(Stream fileStream, string fileName);
    }

    public class BlobService : IBlobService
    {
        private readonly string _connectionString;
        private readonly string _containerName = "raceday-images";

        public BlobService(IConfiguration config)
        {
            // This connection string works with the local Azurite emulator
            _connectionString = config["AzureStorage:ConnectionString"]
                ?? "UseDevelopmentStorage=true";
        }

        public async Task<string> UploadFileAsync(Stream fileStream, string fileName)
        {
            var blobServiceClient = new BlobServiceClient(_connectionString);
            var containerClient = blobServiceClient.GetBlobContainerClient(_containerName);

            // Create container if it doesn't exist and allow public access to read images
            await containerClient.CreateIfNotExistsAsync(PublicAccessType.Blob);

            var blobClient = containerClient.GetBlobClient(fileName);
            await blobClient.UploadAsync(fileStream, true);

            return blobClient.Uri.ToString();
        }
    }
}