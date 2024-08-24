var builder = DistributedApplication.CreateBuilder(args);

var apiService = builder.AddProject<Projects.TestTask_Api>("apiservice");

builder.AddNpmApp("frontend", "../TestTask.Client")
    .WithReference(apiService)
    .WithHttpEndpoint(env: "PORT", targetPort: 4200)
    .WithExternalHttpEndpoints();

builder.Build().Run();
