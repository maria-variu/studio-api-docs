Project Creator
==

This class transforms a list of ProjectRequests into the corresponding file based projects using a project template.

This task is carried out by the Execute method. It calls the CreateProject method for each request and using the CreateProject method in the Project Automation API creates a new instance of FileBasedProject and adds files from the ProjectRequest object. It then uses FileBasedProjectReference to run a Scan task on the files followed by a DefaultTaskSequence after which it saves the new project. The sample also illustrates how the ProgressChanged and MessageReported events are handled.

# [C#](#tab/tabid-1)
```cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Sdl.TranslationStudioAutomation.IntegrationApi;
using Sdl.ProjectAutomation.FileBased;
using System.ComponentModel;
using Sdl.ProjectAutomation.Core;
using System.IO;

namespace StudioIntegrationApiSample
{
    class ProjectCreator
    {
        public event ProgressChangedEventHandler ProgressChanged;
        public event EventHandler<ProjectMessageEventArgs> MessageReported;
        private double _currentProgress;

        public ProjectCreator(List<ProjectRequest> requests, ProjectTemplateInfo projectTemplate)
        {
            Requests = requests;
            ProjectTemplate = projectTemplate;
            SuccessfulRequests = new List<Tuple<ProjectRequest, FileBasedProject>>();
        }

        List<ProjectRequest> Requests
        {
            get; set;
        }

        public List<Tuple<ProjectRequest, FileBasedProject>> SuccessfulRequests
        {
            get;
            private set;
        }

        ProjectTemplateInfo ProjectTemplate
        {
            get;
            set;
        }

        public void Execute()
        {
            _currentProgress = 0;
            foreach (ProjectRequest request in Requests)
            {
                CreateProject(request);
                _currentProgress += 100.0 / Requests.Count;
                OnProgressChanged(_currentProgress);
            }

            OnProgressChanged(100);
        }

        private FileBasedProject CreateProject(ProjectRequest request)
        {
            ProjectInfo projectInfo = new ProjectInfo
            {
                Name = request.Name,
                LocalProjectFolder = GetProjectFolderPath(request.Name)
            };
            FileBasedProject project = new FileBasedProject(projectInfo, new ProjectTemplateReference(ProjectTemplate.Uri));

            OnMessageReported(project, String.Format("Creating project {0}", request.Name));

            ProjectFile[] projectFiles = project.AddFiles(request.Files);
            project.RunAutomaticTask(projectFiles.GetIds(), AutomaticTaskTemplateIds.Scan); 
            TaskSequence taskSequence = project.RunDefaultTaskSequence(projectFiles.GetIds(),
                (sender, e)
                    =>
                {
                    OnProgressChanged(_currentProgress + (double)e.PercentComplete / Requests.Count);
                }
                , (sender, e)
                =>
                { 
                   OnMessageReported(project, e.Message);
                });

            project.Save();

            if (taskSequence.Status == TaskStatus.Completed)
            {
                SuccessfulRequests.Add(Tuple.Create(request, project));
                OnMessageReported(project, String.Format("Project {0} created successfully.", request.Name));
                return project;
            }
            else
            {
                OnMessageReported(project, String.Format("Project {0} creation failed.", request.Name));
                return null;
            }
        }

        private string GetProjectFolderPath(string name)
        {
            string rootFolder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "Studio 2015\\Projects");
            string folder;
            int num = 1;
            do 
            {
                num++;
            }
            while (Directory.Exists(folder = Path.Combine(rootFolder, name + "-" + num)));
            return folder;
        }



        private void OnProgressChanged(double progress)
        {
            if (ProgressChanged != null)
            {
                ProgressChanged(this, new ProgressChangedEventArgs((int)progress, null));
            }
        }

        private void OnMessageReported(FileBasedProject project, string message)
        {
            if (MessageReported != null)
            {
                MessageReported(this, new ProjectMessageEventArgs { Project = project, Message = message });
            }
        }

        private void OnMessageReported(FileBasedProject project,ExecutionMessage executionMessage)
        {
             if (MessageReported != null)
            {
                MessageReported(this, new ProjectMessageEventArgs {Project = project, Message = executionMessage.Level + ": " + executionMessage.Message});
            }
        }
    }

    class ProjectMessageEventArgs : EventArgs
    {
        public FileBasedProject Project { get; set; }

        public string Message {get; set;}
    }

}
```
***


See Also
--



[Content Connector](content_connector.md)

[Reference Sample](reference_sample.md)

[Wikipedia Search](wikipedia_search.md)

[Integrating actions](integrating_actions.md)

[Integrating ribbon groups](integrating_ribbon_groups.md)

[Integrating viewparts](integrating_viewparts.md)

[Integrating views](integrating_views.md)
