using Microsoft.AspNetCore.Mvc;
using TestTask.Core.Models;
using TestTask.Services;

namespace TestTask.Api.Controllers;

[ApiController]
[Route("/api/v1")]
public class CategoryController : ControllerBase
{
    private readonly ILogger<CategoryController> _logger;
    private readonly CategoryService _categoryService;

    public CategoryController
        (ILogger<CategoryController> logger,
        CategoryService categoryService)
    {
        _logger = logger;
        _categoryService = categoryService;
    }

    [HttpGet]
    [Route("categories")]
    public async Task<IEnumerable<Category>> Get()
    {
        return await _categoryService.GetAll();
    }
}
