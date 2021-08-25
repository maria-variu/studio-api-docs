Add a Resources File
===

In this step you add a resources file for storing the strings, which users will see in the user interface of <Var:ProductName>.

Add a resource file to your project and call it e.g. ```StringResources.resx```. To properly inform the user of any length limit violations, a message should display the following information:

* The actual length limit as specified in the **maxlength** attribute.
* The target segment text that was found to be longer than the specified length limit.
* The name of the plug-in that has detected the problem. This is important, as a user might run several verifiers at the same time (e.g. the QA Checker, the Generic Tag Verification, and our length checker sample implementation). By including the name of the verification plug-in that generated an error, the user will know from verifier a particular message came. In the **Messages** window of <Var:ProductName> users can also sort error messages by plug-in name.

Therefore, your resources file should look as shown below:

![ResourcesXMLChecker](images/ResourcesXMLChecker.jpg)

Below you see an example of an error message as it might be generated by our sample plug-in:

![Error_Message_Maxlength_XML_Exceeded](images/Error_Message_Maxlength_XML_Exceeded.jpg)

>[!NOTE]
>
> This content may be out-of-date. To check the latest information on this topic, inspect the libraries using the Visual Studio Object Browser.