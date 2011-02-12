

IN YOUR APPLICATION.CFC IT WOULD LOOK SOMETHING LIKE:

<cfscript>
  function setupApplication(){ 

    //the bean factory we'll use
    serviceFactory = createObject("component","services/servicefactory").init();
    
    //the user service
    serviceFactory.registerService(
      "user",
      createObject("component","services/userservice").init("mydsn")
    );
    
    //the auth service
    serviceFactory.registerService(
      "auth",
      createObject("component","services/authservice").init(
        serviceFactory.getService("user")
      )
    );
        
    //set the beanFactory
    setBeanFactory(serviceFactory);
  }
</cfscript>



NOW, IN YOUR CONTROLLERS YOU CAN DO THIS:

<cfscript>
userService = fw.getBeanFactory().getService("user");
</cfscript>

ALTERNATIVELY, in the init() of your controllers you can do this to create a simple private reference to all services, keyed by name:

<cfscript>
variables.services = fw.getBeanFactory().getRegisteredServices();  
</cfscript>
