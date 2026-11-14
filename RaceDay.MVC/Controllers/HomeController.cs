using Microsoft.AspNetCore.Mvc;
using RaceDay.MVC.Models;
using RaceDay.MVC.Services;
using System.Diagnostics;

namespace RaceDay.MVC.Controllers
{
    public class HomeController : Controller
    {
        private readonly IApiService _apiService;

        // Inject the API service
        public HomeController(IApiService apiService)
        {
            _apiService = apiService;
        }

        // This is the main page where users browse events
        public async Task<IActionResult> Index()
        {
            // Get events from the API
            var events = await _apiService.GetEventsAsync();
            return View(events);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}