using Microsoft.EntityFrameworkCore;
using RaceDay.API.Data;
using RaceDay.API.DTOs.Auth;
using RaceDay.API.Services;
using Xunit;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;

namespace RaceDay.API.Tests
{
    public class AuthTests
    {
        private RaceDayDbContext GetInMemoryDbContext()
        {
            var options = new DbContextOptionsBuilder<RaceDayDbContext>()
                .UseInMemoryDatabase(databaseName: System.Guid.NewGuid().ToString())
                .Options;
            return new RaceDayDbContext(options);
        }

        [Fact]
        public async Task Register_ValidParticipant_ReturnsToken()
        {
            var context = GetInMemoryDbContext();
            // Setup mock config for TokenService
            var inMemorySettings = new Dictionary<string, string> {
                {"Jwt:Key", "SuperSecretKeyForTestingPurposesOnly12345!"},
                {"Jwt:Issuer", "TestIssuer"},
                {"Jwt:Audience", "TestAudience"},
                {"Jwt:DurationInMinutes", "60"}
            };
            IConfiguration configuration = new ConfigurationBuilder()
                .AddInMemoryCollection(inMemorySettings)
                .Build();

            var tokenService = new TokenService(configuration);
            var authService = new AuthService(context, tokenService);

            var dto = new RegisterDto
            {
                Email = "test@email.com",
                Password = "Password123",
                Full_Name = "Test User",
                Role = "Participant"
            };

            // Act
            var result = await authService.RegisterAsync(dto);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("test@email.com", result.Email);
            Assert.Equal("Participant", result.Role);
            Assert.NotEmpty(result.Token);
        }
    }
}