# secure-dotnet-api-codeql
🔐 Secure .NET 8 Web API using GitHub Copilot, CodeQL, Dependabot, and GitHub Actions. Learn to identify and fix vulnerabilities, enforce CI security, and automate safe development practices.

## 🧱 Overview

| Component | Description                                                                 |
| --------- | --------------------------------------------------------------------------- |
| App       | .NET 8 Web API (`UserApp`)                                              |
| Focus     | Secure development with CodeQL, Copilot, and GitHub Advanced Security       |
| Tools     | GitHub Copilot, CodeQL, Dependabot, GitHub Actions, markdownlint            |
| Security  | Secret Scanning, Push Protection, Custom CodeQL Queries, Org Policies       |
| DevOps    | CI/CD workflows, vulnerability detection, dependency management             |
| Docs      | XML Comments, Markdown Docs, Security Policies, GraphQL Querying            |

---

## 🎯 Objectives

1. Scaffold a .NET 8 Web API project (`UserApp`)
2. Implement clean architecture: model, service, controller
3. Inject insecure logic (e.g. hardcoded secrets, raw SQL)
4. Refactor with Copilot using secure coding practices
5. Load secrets via `appsettings.json` and configuration
6. Add required NuGet packages (e.g., SqlClient)
7. Document APIs with XML comments
8. Create `INSTRUCTIONS.md` and `CONTRIBUTING.md`
9. Add CI pipeline with GitHub Actions for build/test
10. Enable secret scanning, push protection, and dependency graph
11. Configure CodeQL static analysis for C#
12. Build a custom CodeQL query to detect hardcoded secrets
13. Add Dependabot for NuGet security updates
14. Enforce organization-wide CodeQL policies (GHES)
15. Query vulnerability alerts via GitHub Security GraphQL API


---

## ✅ Step 1: Scaffold the .NET 8 Project

> *Copilot Prompt: \
> Provid CLI commands to create a .NET 8 Web API project called `UserApp` in the current directory.\
> Then create the folders: `Models`, `Services`, and `Controllers` inside the project folder.*

### **✅ Expected Outcome:**
```bash
# Create a new .NET 8 Web API project named UserApp
dotnet new webapi -n UserApp

# Create the Models, Services, and Controllers folders inside the UserApp project
mkdir -p UserApp/Models UserApp/Services UserApp/Controllers
```

---

## ✅ Step 2: Define the Clean Architecture

> *Copilot Prompt: \
> Create the files `User` class, `UserService` class, and `UserController` class \
> Provide code for `User` modeel, `UserService` and  `UserController` with `/api/user?id=` endpoint.

### **✅ Expected Outcome:**

#### 📄 Models/User.cs

```csharp
public class User
{
    public int Id { get; set; }
    public string Email { get; set; }
    public string Name { get; set; }
}
```

#### 📄 Services/UserService.cs

```csharp
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
```

#### 📄 Controllers/UserController.cs

```csharp
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

        public UserController()
        {
            _userService = new UserService();
        }

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
    }
}
```

---

## ✅ Step 3: Add Configuration and Secrets and Update Program.cs 

> **Copilot Prompt:**  
> Create an `appsettings.json` file with a custom `ApiKey` and a connection string named `Default` for a local SQL Server.

### **✅ Expected Outcome:**

### 📄 appsettings.json

```json
{
  "ApiKey": "sk_secure_configured_123",
  "ConnectionStrings": {
    "Default": "Server=.;Database=TestDb;Trusted_Connection=True;"
  }
}
```


> **Copilot Prompt:**  
> Add the required lines in `Program.cs` to enable MVC controller support in a .NET 8 Web API using:
> `builder.Services.AddControllers()` and `app.MapControllers()`.
### **✅ Expected Outcome:**

### 📄 Program.cs

```csharp
builder.Services.AddControllers();
// ...existing code...
app.MapControllers();
```


### 🧪 Test the API

> **Copilot Prompt:**  
> Run the app
### **✅ Expected Outcome:**

```bash
dotnet run --project UserApp/UserApp.csproj
```

---

## ✅ Step 4: Demonstrate Insecure Version (Before Copilot Fix)

> **Copilot Prompt:**  
> Modify the existing `UserController` to simulate insecure logic:  
> - Add a hardcoded API key as a static string.  
> - Add a second GET method that retrieves a user by email using raw SQL string concatenation.

### **✅ Expected Outcome:**

```csharp
[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private static string API_KEY = "sk_test_123";

         // ... existing code ...

        // Insecure endpoint: GET /api/user/email?email=alice@example.com
        [HttpGet("email")]
        public IActionResult GetUserByEmail([FromQuery] string email)
        {
            // Insecure: raw SQL query with user input
            var query = $"SELECT * FROM Users WHERE Email = '{email}'";
            // Simulate execution (do not actually run SQL)
            return Ok(new { ApiKey = API_KEY, Query = query });
        }
}
```

---

## ✅ Step 5: Refactor Using GitHub Copilot

> **Copilot Prompt:** 
> - Identify if the SQL logic is vulnerable to injection.  
> - Refactor the method to use `SqlCommand` with parameterized queries.  
> - Move the hardcoded `API_KEY` into `appsettings.json`.  
> - Inject the configuration value using `IConfiguration` and replace the static key.

### **✅ Expected Outcome:**

```csharp
{
    ...
        
    // Secure endpoint: GET /api/user/email?email=alice@example.com
    [HttpGet("email")]
    public IActionResult GetUserByEmail([FromQuery] string email)
    {
        // Secure: use parameterized query
        var apiKey = _config["ApiKey"];
        var connStr = _config.GetConnectionString("Default");
        var query = "SELECT * FROM Users WHERE Email = @email";
        // Simulate parameterized SQL command
        return Ok(new { ApiKey = apiKey, Query = query, Parameter = email, ConnectionString = connStr });
    }
}
```

---

## ✅ Step 6: Add NuGet Package References

> ℹ️ **Copilot Prompt:**  
> Which NuGet package is required to use `SqlConnection` and `SqlCommand` in a .NET 8 Web API? \
> Add the correct package using the CLI.

### **✅ Expected Outcome:**

```bash
dotnet add package Microsoft.Data.SqlClient
```
#### 📦 Purpose of `Microsoft.Data.SqlClient`

- Enables use of ADO.NET classes like `SqlConnection` and `SqlCommand`
- Required to connect to and query SQL Server databases
- Supports secure database access with parameterized queries
- Compatible with .NET 8 and Microsoft SQL Server features

---

## ✅ Step 7: Generate Documentation with Copilot

> **Copilot Prompt:**  
> Add XML documentation to `UserController` methods.  
> - Include a summary that explains what the method does.  
> - Describe the query parameter clearly.  
> - Mention the possible return values and relevant HTTP status codes.

### **✅ Expected Outcome:**

```csharp
/// <summary>
/// Retrieves a user by their unique ID.
/// </summary>
/// <param name="id">Query parameter: the unique identifier of the user.</param>
/// <returns>
/// 200 OK with user data if found, or 404 Not Found if no user exists for the given ID.
/// </returns>
```

---

## ✅ Step 8: Create INSTRUCTIONS.md and CONTRIBUTING.md

> **Copilot Prompt:**
> - "Create INSTRUCTIONS.md with project setup and usage"
> - "Generate CONTRIBUTING.md for new developers"

### **✅ Expected Outcome:**

- `INTRUCTIONS.md`
- `CONTRIBUTING.md`

---

## ✅ Step 9: Add GitHub Actions CI

> **Copilot Prompt:**  
> Create a GitHub Actions workflow `.github/workflows/ci.yaml` for a .NET 8 Web API project.  
> - The project is located in the `UserApp` folder.  
> - Use `dotnet restore`, `dotnet build`, and `dotnet test`.  
> - Trigger the workflow on `push` and `pull_request` to the `main` branch.  
> - Use `ubuntu-latest` as the runner.

### **✅ Expected Outcome:**

```yaml
name: .NET CI
on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: 8.0.x
      - name: Restore
        run: dotnet restore UserApp/UserApp.csproj
      - name: Build
        run: dotnet build UserApp/UserApp.csproj --no-restore
      - name: Test
        run: dotnet test UserApp/UserApp.csproj --no-build --verbosity normal

```
### Commit and Push (Triger ci.yaml)

> **Copilot Prompt:**  
> Provide the commit sequence to push the changes to main

```bash
git add .
git commit -m ".Net CI"
git push origin main
```

---

## ✅ Step 10: Enable Secret Scanning and Push Protection

1. Go to **Settings > Code security and analysis** in GitHub.
2. Enable:
   - ✅ **Secret scanning**
   - 🚦 **Push protection**
   - 📊 **Dependency graph**

---

## ✅ Step 11: Add CodeQL Scan

```yaml
# .github/workflows/codeql.yml
name: CodeQL Scan
on:
  push:
    paths:
      - '**/*.cs'
    branches: [main]
  pull_request:
    paths:
      - '**/*.cs'
    branches: [main]
permissions:
  security-events: write
  contents: read
jobs:
  analyze:
    name: CodeQL Analyze C#
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '8.0.x'
      - uses: github/codeql-action/init@v3
        with:
          languages: csharp
      - run: dotnet build --configuration Release
      - uses: github/codeql-action/analyze@v3
```

---

## ✅ Step 12: Create a Custom CodeQL Query to Detect Hardcoded Secrets

📁 Structure:

```
.github/
└── codeql/
    ├── config.yml
    ├── qlpack.yml
    └── queries/
        └── FindHardcodedSecrets.ql
```

📄 `FindHardcodedSecrets.ql`

```ql
/**
 * @name Find hardcoded secrets in C#
 * @description Detects hardcoded strings that look like secrets
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.0
 * @id cs/hardcoded-secrets
 * @tags security
 */

import csharp

from string_literal s
where
  s.getValue().regexpMatch("(?i).*(sk_.*|token_.*|apikey_.*|[a-zA-Z0-9+/=]{32,})")
select s, "Hardcoded secret detected: '" + s.getValue() + "'"
```

📄 `config.yml`

```yaml
name: "CodeQL Config"
disable-default-queries: false
queries:
  - uses: security-extended
  - uses: .
paths:
  - '**/*.cs'
paths-ignore:
  - '**/test/**'
```

📄 `qlpack.yml`

```yaml
name: userapp/secrets
version: 0.0.1
dependencies:
  codeql/csharp-all: "*"
```

---

## ✅ Step 13: Add Dependabot

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "nuget"
    directory: "/"
    schedule:
      interval: "daily"
    labels:
      - "dependencies"
      - "automerge"
    open-pull-requests-limit: 10
    commit-message:
      prefix: "📦 deps:"
```

---

## ✅ Step 14: Enforce Org-Wide CodeQL Policy *(Enterprise Only)*

```yaml
# .github/codeql/org-policy.yml
name: "Org-Wide CodeQL Policy"
disable-default-queries: false
queries:
  - uses: org/codeql-queries@v1.0.0/csharp/security/FindHardcodedSecrets.ql
  - uses: security-and-quality
languages:
  - csharp
paths:
  - '**/*.cs'
rules:
  - id: cs/hardcoded-secrets
    severity: error
    paths:
      - '**/*.cs'
    mode: block
    message: |
      ❌ Hardcoded secrets detected. Please:
      1. Remove embedded credentials
      2. Use environment variables or secrets config
      3. Follow secure development best practices
```

---

## ✅ Step 15: Use GitHub Security Graph API *(Enterprise Only)*

```graphql
query VulnerabilityAlerts {
  repository(owner: "YOUR_ORG", name: "UserApp") {
    vulnerabilityAlerts(first: 100, states: OPEN) {
      nodes {
        vulnerableManifestPath
        securityVulnerability {
          package {
            name
          }
          severity
          advisory {
            description
          }
        }
      }
    }
  }
}
```

---

## 📊 Summary Table

| Step | Feature                  | Tool / Prompt       | ✅ Outcome                        |
| ---- | ------------------------ | ------------------- | -------------------------------- |
| 1    | Scaffold Project         | `dotnet new webapi` | Ready-to-code API                |
| 2    | Clean Architecture       | Copilot             | Model, Service, Controller       |
| 3    | Config + Secrets         | Copilot Chat        | appsettings + IConfiguration     |
| 4    | Vulnerable Logic         | Manual              | Insecure logic w/ hardcoded key  |
| 5    | Copilot Refactor         | Copilot Chat        | Safer SQL + secrets              |
| 6    | NuGet Packages           | dotnet add package  | Installed SqlClient              |
| 7    | XML Docs                 | `///`               | Method doc added                 |
| 8    | Markdown Docs            | Copilot Chat        | README + CONTRIB                 |
| 9    | CI Workflow              | GitHub Actions      | Build + Test                     |
| 10   | GitHub Security Settings | GitHub UI           | Secret scanning, push protection |
| 11   | CodeQL Scan              | GitHub Actions      | Static security scan             |
| 12   | Custom CodeQL Query      | Copilot + CodeQL    | Detect secrets in C#             |
| 13   | Dependabot               | GitHub Config       | Auto package updates             |
| 14   | Org Policy (GHES)        | CodeQL              | Enforced org-wide rule           |
| 15   | Security API (GHES)      | GraphQL             | Query vulnerabilities            |

---

## 📄 End of Lab

You have now secured, documented, and enforced a modern .NET 8 Web API with GitHub Copilot and GitHub Advanced Security!