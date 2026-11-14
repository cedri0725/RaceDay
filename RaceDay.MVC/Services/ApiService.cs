using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using RaceDay.MVC.Models;

namespace RaceDay.MVC.Services
{
    public class ApiService : IApiService
    {
        private readonly HttpClient _httpClient;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public ApiService(HttpClient httpClient, IHttpContextAccessor httpContextAccessor)
        {
            _httpClient = httpClient;
            _httpContextAccessor = httpContextAccessor;
        }

        // Helper to attach the JWT token from the Session to API requests
        private void AddTokenToHeader()
        {
            var token = _httpContextAccessor.HttpContext?.Session.GetString("JwtToken");
            if (!string.IsNullOrEmpty(token))
            {
                _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            }
        }

        public async Task<string> LoginAsync(string email, string password)
        {
            var loginDto = new { Email = email, Password = password };
            var content = new StringContent(JsonSerializer.Serialize(loginDto), Encoding.UTF8, "application/json");

            var response = await _httpClient.PostAsync("api/auth/login", content);

            if (response.IsSuccessStatusCode)
            {
                var jsonResponse = await response.Content.ReadAsStringAsync();
                using var doc = JsonDocument.Parse(jsonResponse);
                // Assuming your API returns the token in a property called "token"
                return doc.RootElement.GetProperty("token").GetString() ?? "";
            }
            return null; // Login failed
        }

        public async Task<bool> RegisterAsync(string email, string password, string fullName, string role)
        {
            var registerDto = new { Email = email, Password = password, Full_Name = fullName, Role = role };
            var content = new StringContent(JsonSerializer.Serialize(registerDto), Encoding.UTF8, "application/json");

            var response = await _httpClient.PostAsync("api/auth/register", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<List<EventViewModel>> GetEventsAsync()
        {
            AddTokenToHeader();
            var response = await _httpClient.GetAsync("api/events");

            if (response.IsSuccessStatusCode)
            {
                var jsonResponse = await response.Content.ReadAsStringAsync();
                // Note: Your API returns { "events": [ ... ] } so we parse the "events" property
                using var doc = JsonDocument.Parse(jsonResponse);
                var eventsArray = doc.RootElement.GetProperty("events");

                return JsonSerializer.Deserialize<List<EventViewModel>>(eventsArray.GetRawText(), new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new List<EventViewModel>();
            }
            return new List<EventViewModel>();
        }
    }
}