namespace TestTask.Core.Models
{
    public record Category
    {
        public int CategoryId { get; set; }
        public string? CategoryName { get; set; }
        public int? ParentCategoryId { get; set; }
    }
}
