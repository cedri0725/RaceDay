using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RaceDay.MVC.Services;

namespace RaceDay.MVC.Controllers
{
    // [Authorize] means only logged-in users can access this controller
    [Authorize]
    public class DashboardController : Controller
    {
        private readonly IApiService _apiService;

        public DashboardController(IApiService apiService)
        {
            _apiService = apiService;
        }

        public async Task<IActionResult> Index()
        {
            // In a real app, you would filter this to only show the logged-in Organiser's events.
            // For now, we will fetch all events and display them.
            var events = await _apiService.GetEventsAsync();
            return View(events);
        }
    }
}