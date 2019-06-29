# iMovie

- Network Layer:
		The Network layer is responsible to make the requests to the back end, hold a Endpoint enum that contains all the requests, parameters, tokens, etc.
- Persistence Layer:
		The Persistence layer is responsible to save data offline using CoreData.
- Features Structure:
		All the features is made using MVVM architecture, using a View that maintain all the layout changes needed, a ModelView that is used as business layer and use a Model to contain the data. Also, the communication with Network Layer is made using a Service.
- All the application follow the Single Responsability Principle, it means that each class is responsible for only one purpose, this is guarantee by use the MVVM architecture and the layers in the application.
- A good code must follow the SOLID principles, dividing the responsability of each class, keeping easy to do maintenance and easy to work with multiple people. Also must be well understable and tested.
