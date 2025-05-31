# MyNotepad
- Inha Univ. CSE2104 Web Project
- Created by Jaeah Lee

# Getting Started
## Deploy to Tomcat  
To deploy **MyNotepad** on **Apache Tomcat**, follow these steps:

1. **Start the Tomcat Server**  
   - Ensure Tomcat is running before deployment.  

2. **Create a WAR File**  
   - Using **Maven**:  
     ```sh
     mvn clean package
     ```
   - OR using **Gradle**:  
     ```sh
     gradle clean build
     ```
   - The generated `.war` file will be in the `target/` or `build/libs/` directory.

3. **Deploy the WAR File**  
   - Navigate to Tomcat’s `webapps` directory:  
     ```sh
     cd /path/to/tomcat/webapps
     ```
   - Move the generated WAR file to the `webapps/` folder:  
     ```sh
     mv /path/to/MyNotepad.war .
     ```

4. **Verify Deployment**  
   Tomcat will automatically extract and deploy the WAR file.

5. **Access the Web Application**  
   Open your browser and visit:
   ```
   http://localhost:8080/MyWebApp
   ```
