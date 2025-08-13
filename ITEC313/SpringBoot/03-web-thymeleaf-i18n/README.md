# 03-web-thymeleaf-i18n — Spring Boot Web App with Thymeleaf and Internationalization

A comprehensive Spring Boot web application demonstrating server-side templating with Thymeleaf, form handling, validation, and multi-language support.

## Overview

This project showcases modern web development with Spring Boot:
- **Thymeleaf Templates**: Server-side templating for dynamic web pages
- **Internationalization (i18n)**: Multi-language support with locale-based message resolution
- **Form Handling**: Form submission, validation, and error handling
- **Static Resources**: CSS, JavaScript, and responsive design
- **Maven Build System**: Dependency management and build automation

## Features

### Web Application Features
- ✅ Responsive web interface with Bootstrap 5
- ✅ Server-side templating with Thymeleaf
- ✅ Form handling with validation
- ✅ Multi-language support (English, Spanish)
- ✅ Static resource serving (CSS, JS)
- ✅ REST API endpoints
- ✅ Modern UI with animations and interactions

### Application Pages
- **Home Page** (`/`) - Welcome page with feature overview
- **About Page** (`/about`) - Information about the application
- **Contact Form** (`/contact`) - Form with validation and submission
- **Languages Page** (`/languages`) - Language selection and i18n demo

### API Endpoints
- `GET /api/time` - Get current server time
- `GET /api/time?format=short` - Get time in short format

### Supported Languages
- 🇺🇸 English (en_US) - Default
- 🇪🇸 Spanish (es_ES) - Implemented
- 🇫🇷 French (fr_FR) - Placeholder
- 🇩🇪 German (de_DE) - Placeholder
- 🇮🇹 Italian (it_IT) - Placeholder

## Prerequisites

- Java 17 or higher
- Maven 3.9 or higher
- Modern web browser (Chrome, Firefox, Safari, Edge)

## Quick Start

### 1. Build the Application

```bash
cd 03-web-thymeleaf-i18n
mvn clean compile
```

### 2. Run the Application

```bash
mvn spring-boot:run
```

### 3. Access the Application

Open your web browser and navigate to:
- **Main Application**: http://localhost:8080
- **Home Page**: http://localhost:8080/
- **About Page**: http://localhost:8080/about
- **Contact Form**: http://localhost:8080/contact
- **Languages Page**: http://localhost:8080/languages

### 4. Test the Application

**Automated testing:**
```bash
# Run the test script
./scripts/test_endpoints.sh

# Or with custom base URL
BASE_URL=http://localhost:8080 ./scripts/test_endpoints.sh
```

**Manual testing:**
- Navigate through all pages
- Test the contact form with valid and invalid data
- Switch between languages using the dropdown
- Test responsive design on different screen sizes

### 5. Run Tests

```bash
mvn test
```

## Configuration

### Thymeleaf Configuration
- Template cache disabled for development
- UTF-8 encoding
- HTML mode with proper content type

### Internationalization Configuration
- Message source: `messages.properties`
- UTF-8 encoding for international characters
- Locale resolver: Session-based
- Locale change interceptor: URL parameter `lang`

### Static Resources
- CSS: `/css/style.css`
- JavaScript: `/js/app.js`
- Cache disabled for development

## Project Structure

```
03-web-thymeleaf-i18n/
├── src/
│   ├── main/
│   │   ├── java/com/acu/webapp/
│   │   │   ├── WebAppApplication.java          # Main application class
│   │   │   ├── config/
│   │   │   │   └── LocaleConfig.java          # i18n configuration
│   │   │   ├── model/
│   │   │   │   └── User.java                  # Form model with validation
│   │   │   └── controller/
│   │   │       └── WebController.java         # Web controller
│   │   └── resources/
│   │       ├── templates/
│   │       │   ├── layout.html                # Base layout template
│   │       │   ├── home.html                  # Home page template
│   │       │   ├── about.html                 # About page template
│   │       │   ├── contact.html               # Contact form template
│   │       │   └── languages.html             # Languages page template
│   │       ├── static/
│   │       │   ├── css/
│   │       │   │   └── style.css              # Custom styles
│   │       │   └── js/
│   │       │       └── app.js                 # Custom JavaScript
│   │       ├── messages.properties            # Default messages (English)
│   │       ├── messages_es.properties         # Spanish messages
│   │       └── application.yml                # Application configuration
│   └── test/
│       └── java/com/acu/webapp/
│           ├── WebAppApplicationTests.java
│           └── controller/
│               └── WebControllerTest.java
├── scripts/
│   └── test_endpoints.sh                      # Endpoint testing script
├── pom.xml                                    # Maven configuration
└── README.md                                  # This file
```

## Key Spring Boot Concepts Demonstrated

### 1. Thymeleaf Integration
- **Template Engine**: Server-side rendering with Thymeleaf
- **Layout Dialect**: Template inheritance and composition
- **Form Binding**: Automatic form field binding and validation
- **Internationalization**: Message resolution in templates

### 2. Internationalization (i18n)
- **Message Sources**: Properties files for different languages
- **Locale Resolver**: Session-based locale management
- **Locale Change Interceptor**: URL-based language switching
- **Message Resolution**: Automatic message lookup in templates

### 3. Form Handling
- **Model Binding**: Automatic form data binding to objects
- **Validation**: Bean validation with custom error messages
- **Error Handling**: Display validation errors in templates
- **Flash Messages**: Success/error messages after form submission

### 4. Static Resource Management
- **Resource Handlers**: Automatic static resource serving
- **CSS Integration**: Custom styles with Bootstrap
- **JavaScript Integration**: Client-side functionality
- **Cache Control**: Development-friendly caching settings

### 5. Web Controller Patterns
- **@Controller**: Web page controllers
- **Model Attributes**: Data passing to templates
- **Form Processing**: GET/POST request handling
- **Redirect Attributes**: Flash message support

## Learning Resources

### Official Documentation
- [Serving Web Content with Spring Boot](https://spring.io/guides/gs/serving-web-content/)
- [Spring Boot Thymeleaf](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.templating)
- [Spring Boot Internationalization](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-controller/ann-methods/initbinder.html)

### Tutorials
- [Thymeleaf Tutorial](https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html)
- [Spring Boot i18n (Baeldung)](https://www.baeldung.com/spring-boot-internationalization)
- [Spring Boot Maven Plugin](https://docs.spring.io/spring-boot/docs/current/maven-plugin/reference/htmlsingle/)

## Next Steps

After completing this web application tutorial, you can explore:

1. **Day 4**: Advanced REST services and consuming external APIs
2. **Day 5**: Data JPA and database integration
3. **Day 6**: Kafka messaging, email, and scheduling
4. **Day 7**: Microservices and testing strategies

## Troubleshooting

### Common Issues

1. **Templates not rendering**: Check Thymeleaf cache settings and template location
2. **Static resources not loading**: Verify static resource configuration and file paths
3. **Form validation not working**: Ensure validation annotations and error handling
4. **Language switching not working**: Check locale resolver and interceptor configuration

### Development Tips

1. **Template Development**: Use browser developer tools to inspect rendered HTML
2. **CSS Development**: Use browser dev tools for responsive design testing
3. **JavaScript Debugging**: Check browser console for JavaScript errors
4. **Form Testing**: Test with various input combinations and edge cases

### Logs

Check the console output for:
- Application startup logs
- Thymeleaf template processing logs
- Form validation logs
- Static resource serving logs

## Contributing

This is a learning project. Feel free to experiment with:
- Adding new pages and templates
- Implementing additional languages
- Enhancing form validation
- Adding new static resources
- Improving the UI/UX design
- Adding new API endpoints

## Browser Compatibility

The application is tested and works with:
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Performance Considerations

- **Development**: Cache disabled for live reloading
- **Production**: Enable caching for better performance
- **Static Resources**: Consider CDN for production deployment
- **Templates**: Use template fragments for better maintainability
