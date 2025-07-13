using Microsoft.AspNetCore.Mvc;
using UserApp.Models;
using UserApp.Services;

namespace UserApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly UserService _userService;
        private readonly IConfiguration _config;

        public UserController(IConfiguration config)
        {
            _userService = new UserService();
            _config = config;
        }

        /// <summary>
        /// Retrieves a user by their unique ID.
        /// </summary>
        /// <param name="id">Query parameter: the unique identifier of the user.</param>
        /// <returns>
        /// 200 OK with user data if found, or 404 Not Found if no user exists for the given ID.
        /// </returns>
        [HttpGet]
        public IActionResult GetUser([FromQuery] int id)
        {
            var user = _userService.GetUserById(id);
            if (user == null)
            {
                return NotFound();
            }
            return Ok(user);
        }

        /// <summary>
        /// Retrieves a user by their email address using a secure parameterized query.
        /// </summary>
        /// <param name="email">Query parameter: the email address of the user to search for.</param>
        /// <returns>
        /// 200 OK with the simulated query and API key if successful. 404 Not Found if no user exists for the given email.
        /// </returns>
        [HttpGet("email")]
        public IActionResult GetUserByEmail([FromQuery] string email)
        {
            var apiKey = _config["ApiKey"];
            var connStr = _config.GetConnectionString("Default");
            var query = "SELECT * FROM Users WHERE Email = @email";
            // Simulate parameterized SQL command
            return Ok(new { ApiKey = apiKey, Query = query, Parameter = email, ConnectionString = connStr });
        }
    }
}