using TestTask.Core.Models;

namespace TestTask.Services
{
    public class CategoryService
    {
        private List<Category> _categories = new List<Category>
        {
            new Category { CategoryId = 1, CategoryName = "Fruits", ParentCategoryId = null },
            new Category { CategoryId = 2, CategoryName = "Apples", ParentCategoryId = 1 },
            new Category { CategoryId = 3, CategoryName = "Granny Smith", ParentCategoryId = 2 },
            new Category { CategoryId = 4, CategoryName = "Bananas", ParentCategoryId = 1 },
            new Category { CategoryId = 5, CategoryName = "Vegetables", ParentCategoryId = null },
            new Category { CategoryId = 6, CategoryName = "Leafy Greens", ParentCategoryId = 5 },
            new Category { CategoryId = 7, CategoryName = "Lettuce", ParentCategoryId = 6 },
            new Category { CategoryId = 8, CategoryName = "Root Vegetables", ParentCategoryId = 5 }
        };

        public async Task<ICollection<Category>> GetAll()
        {
            return _categories;
        }
    }
}

