# Mirage
## _Steps to Run_

Mirage is a private repositery written in SwiftUI+Swift bringing the upcoming awesome social AR app first of its kind. Mirage uses SPM for its libraries and package resolver will automatically resolve package graph upon initial launch. 'main' branch is used for release purpose only and configured with XCode Cloud Internal+External relase. So before pushing any changes into main branch, please consult with iOS Mentor or Fiig. For any changes, create a separate branch representing the task, then create a pull request based into 'dev' branch. 'main' is only set to be updated at time of release. To make code executeable, follow the steps after cloning 'dev' branch.

## Steps to Run
### Mapbox Setup
The first step is to setup mapbox before opening project in xcode. Xcode will start automatically resolving packages. Before that, Mapbox token should be setup using [mapbox documention's](https://docs.mapbox.com/ios/maps/guides/install/) sections 'Configure secret' and 'configure public token'. 

Once done, xcode will be able to compile and run code now after '.netrc' files is created in home directory. 
PS: For secret token, please consult with Fiig or iOS Menntor. 

## Steps for Code Generation

### Apollo
In Mirage, GraphQL is implemented using [Apollo iOS SDK](https://github.com/apollographql/apollo-ios). The structure is as follows under Project Root:
###### Apollo Folder: /Mirage/Source/Networking/Apollo/
Containts Source used to manage Apollo. 'Apollo Core' Contains Common code being used to interact with Apollo Communication with server. Repositeries Folder contains extension 'ApolloRepositer' based on every module. 'Mutations' contains the graphQL Mutations APIs files that we are going to add into our project e.g. updateUser, authenticate user APIs etc. 'Queries' are the graphQL Get APIs eg getProfile, getMiras etc. Details of APIs given at [Mirage's Notion Page](https://www.notion.so/miragedrop/GRAPH-API-REFERENCE-771ed1428c6f439cb21a6521f4233aad).
Whenever we want to add a new query or mutation, we need add the ***.graphql file in either of these two folder based on the type of operation. 

###### Apollo Folder: /Mirage/Schema/
Contains the schema and Apollo Generate code inside it. Whenever there's a change in API (i.e. to add new Query/Mutation). Both schema.graphqls and schema.json will require to be updated. And when we run Apollo generate command. Files will be created in ApolloGenerated Folder. 

To add/update Apollo generated files. Following steps are required to be taken care off. 
### Steps to Integrate Appollo:
There are two steps to make Apollo Generate command able to be executeable
#### Installing appollo_cli
When SPM will finish resolving package graph. apollo-ios-cli is required to be downloaded before running appollo generate command. (PS: Xcode 14.3 had some issues while downloading apollo-ios-cli. So use an older version or equal to XCode 14.2.1 and then copy apollo-ios-cli orignal file to some safer place because cleaning will delete the cli file from build folder). The process is explained below and can also be found at [Apollo SDK](https://www.apollographql.com/docs/ios/code-generation/codegen-cli) in 'SPM with XCode Project' section.


The Apollo iOS SPM package includes the Codegen CLI as an executable target. This ensures you always have a valid CLI version for your Apollo iOS version. To simplify accessing the Codegen CLI, you can run the included InstallCLI SPM plugin.
This plugin builds the CLI and creates a symbolic link to the executable in your project root. If you use Swift packages through Xcode, you can right-click on your project in the Xcode file explorer, revealing an Install CLI plugin command. Selecting this command presents a dialog allowing you to grant the plugin "write" access to your project directory. [Visual Image](apollographql.com/docs/141df0a63f768d56e3a7e9100bb32cb1/apollo-xcode-plugin.png)

After the plugin installs, it creates a symbolic link to the Codegen CLI (named apollo-ios-cli) in your project root folder. You can now run the CLI from the command line with ./apollo-ios-cli.
Note: Because the apollo-ios-cli in your project root is only a symbolic link, it only works if the compiled CLI executable exists. This is generally located in your Xcode Derived Data or the .build folder. If these are cleared, you can rerun the Install CLI plugin to rebuild the CLI executable.

#### Running Apoolo Generate Command
1. Update both schema files in /Mirage/Schema/ folder. For this, copy SDL schema from [Mirage Apollo Studio](https://studio.apollographql.com/sandbox/schema/sdl) and paste into schema.graphqls (please be carefull with 'dev' and 'production' schemas by matching urls. Consult with iOS Mentor in case of details). Now download the schema in json format from same url and replace schema.json file with that file. 
2. Add or Update the query/mutation file in respect 'Queries' or 'Mutations' folder under /Mirage/Source/Networking/Apollo/. The desired syntax can be found either at [Mirage's Notion Page](https://www.notion.so/miragedrop/GRAPH-API-REFERENCE-771ed1428c6f439cb21a6521f4233aad) or can be found at [Mirage Apollo Studio](https://studio.apollographql.com/sandbox?endpoint=https%3A%2F%2Fgraph-dev.protocol.im%2F). 
3. And then in terminal, go to project directory & run 
```sh
./apollo-ios-cli generate
```
4. This will generate files in /Mirage/Schema/ApolloGenerated/<Different Folders based on opration type and>. It may contains objects, enums etc. For now, developer is requried to add all the newly generated files in xcode. This can be done by removing reference of 'ApolloGenerated' folder and re-adding it in xcode project. 
5. After this Code will have access to apollo generated code

### SwiftGen
Mirage uses SwiftGen for Assets. For this, use [brew installtion](https://formulae.brew.sh/formula/swiftgen) to install Swiftgen if not pre-installed. And then in terminal, go to project directory & run 
```sh
swiftgen
```
The required files will be updated/created if there is any change in the asset catalogs. Normally changes by this step are already committed so this step may be on need only. 


_For any further help. Contact Fiig or iOS Mentor._
