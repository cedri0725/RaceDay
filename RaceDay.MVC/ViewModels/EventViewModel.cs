namespace RaceDay.MVC.ViewModels
{
    public class EventViewModel
    {
        public int Event_ID { get; set; }
        public string Event_Name { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
        public DateTime Event_Date { get; set; }
        public int Max_Capacity { get; set; }
    }
}