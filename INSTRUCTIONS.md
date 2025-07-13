# INSTRUCTIONS.md

## Project Setup

1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd secure-dotnet-api-codeql
   ```
2. Install .NET 8 SDK if not already installed.
3. Restore dependencies:
   ```bash
   dotnet restore UserApp/UserApp.csproj
   ```
4. Build the project:
   ```bash
   dotnet build UserApp/UserApp.csproj
   ```
5. Run the API:
   ```bash
   dotnet run --project UserApp/UserApp.csproj
   ```

## Usage

- Access the API endpoints:
  - Get user by ID: `GET /api/user?id=1`
  - Get user by email: `GET /api/user/email?email=alice@example.com`
- API configuration is managed in `UserApp/appsettings.json`.
- Swagger UI is available at `/swagger` for interactive API documentation.

## Security & Code Quality

- CodeQL and Dependabot are enabled for automated security and dependency updates.
- Secret scanning and push protection are enforced via GitHub settings.
- Custom CodeQL queries detect hardcoded secrets.

---
For more details, see the README.md and CONTRIBUTING.md files.
