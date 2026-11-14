using Microsoft.AspNetCore.Mvc;
using RaceDay.MVC.ViewModels;
using System.Net.Http.Headers;
using System.Net.Http.Json;

namespace RaceDay.MVC.Controllers
{
    public class DashboardController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;

        public DashboardController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        public async Task<IActionResult> Index()
        {
            var client = _httpClientFactory.CreateClient("RaceDayAPI");
            var token = HttpContext.Session.GetString("JWToken");

            if (string.IsNullOrEmpty(token))
                return RedirectToAction("Login", "Account");

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            // We can fetch events here to show on the dashboard
            var response = await client.GetAsync("api/events");
            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadFromJsonAsync<EventListResponse>();
                return View(json?.Events ?? new List<EventViewModel>());
            }

            return View(new List<EventViewModel>());
        }
    }
}