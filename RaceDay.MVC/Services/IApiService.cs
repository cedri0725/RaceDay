using RaceDay.MVC.Models; // We will create this folder next

namespace RaceDay.MVC.Services
{
    public interface IApiService
    {
        Task<string> LoginAsync(string email, string password);
        Task<bool> RegisterAsync(string email, string password, string fullName, string role);
        Task<List<EventViewModel>> GetEventsAsync();
        // We will add more methods here later (Enrol, Create Event, etc.)
    }
}