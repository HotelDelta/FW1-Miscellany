<cfcomponent output="false" hint="A lightweight 'factory' that allows use to use arbitrary singleton services native to FW/1 while maintaining control over their instantiation">
  <cffunction name="init" returntype="serviceFactory" access="public" output="false">
    <cfscript>
      variables.instance = {};
      instance.services = {};
      instance.fw1Services = {};
      return this;
    </cfscript>
  </cffunction>
  
  <cffunction name="registerService" returntype="component" access="public" output="false" hint="Adds a service to this instance of the factory">
    <cfargument name="key" type="string" required="true" hint="The key name of the service you want to register" />
    <cfargument name="service" type="component" required="true" hint="An instance of the service you want to register" />
    <cfscript>
      instance.services[arguments.key] = arguments.service;
      instance.fw1Services[arguments.key & "service"] = arguments.service;
      return arguments.service;
    </cfscript>
  </cffunction>
  
  <!---  ::::::::::::::::::::::::::::::::::::::::::::::::::::
    //THESE ARE A CONVENIENCE, SO THAT YOU CAN ASK THE FACTORY KNOWING ONLY THE KEY, NOT THE WAY FW/1 DOES AUTO-APPENDING "SERVICE"
  :::::::::::::::::::::::::::::::::::::::::::::::::::::  --->
  <cffunction name="getService" returntype="component" access="public" output="false" hint="Given a service key, get that service">
    <cfargument name="key" type="string" required="true" hint="The key for the service that was added using registerService" />
    <cfreturn instance.services[arguments.key] />
  </cffunction>
  
  <cffunction name="containsService" returntype="boolean" access="public" output="false" hint="Whether a given service, based on a key, exists">
    <cfargument name="key" type="string" required="true" hint="name of the 'bean' to look for" />
    <cfreturn structKeyExists(instance.services,arguments.key) /> 
  </cffunction>
  
  <cffunction name="getRegisteredServices" returntype="struct" access="public" output="false" hint="Gets the full index of registered services.  Used primarily as a convenience for injecting the services into the controllers">
    <cfreturn instance.services />
  </cffunction>
  
  <!---  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    // THESE ARE THE METHODS FW/1 NEEDS - THEY BOTH USE THE METHODS FOR PASSING A KEY, BUT FW/1 WILL ASK FOR THE key CONCATENATED WITH "service"
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::    --->
  
  <cffunction name="containsBean" returntype="boolean" access="public" output="false" hint="The method FW/1 needs to determine if a bean exists">
    <cfargument name="name" type="string" required="true" hint="name of the 'bean' to look for" />
    <cfreturn structKeyExists(instance.fw1Services,arguments.name) />    
  </cffunction>
  
  <cffunction name="getBean" returntype="component" access="public" output="false" hint="The method FW/1 uses to get the service back">
    <cfargument name="name" type="string" required="true" hint="name of the service to get" />
    <cfreturn instance.fw1Services[arguments.name] />
  </cffunction>
</cfcomponent>