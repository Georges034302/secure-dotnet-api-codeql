using UserApp.Models;

namespace UserApp.Services
{
    public class UserService
    {
        private static readonly List<User> Users = new()
        {
            new User { Id = 1, Name = "Alice", Email = "alice@example.com" },
            new User { Id = 2, Name = "Bob", Email = "bob@example.com" }
        };

        public User? GetUserById(int id)
        {
            return Users.FirstOrDefault(u => u.Id == id);
        }
    }
}
