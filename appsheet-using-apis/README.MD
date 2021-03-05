# AppSheet Using Data from APIs

## Scenario

You have an AppSheet app that needs to consume data from an API.  

## Instructions

### Create a proxy in Apigee that returns data in the expected format. 

1. AssignMessage policy to return car makes

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<AssignMessage name="AM-SetMakesResponse">
    <AssignTo createNew="false" type="response"/>
    <Set>
        <Payload contentType="application/json">{ makes: [
            { name: "Toyota", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/2018_Toyota_Prius_c_%28NHP10R%29_hatchback_%282018-10-29%29_01.jpg/220px-2018_Toyota_Prius_c_%28NHP10R%29_hatchback_%282018-10-29%29_01.jpg" },
            { name: "Lexus", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/2017-03-07_Geneva_Motor_Show_1217.JPG/220px-2017-03-07_Geneva_Motor_Show_1217.JPG" }
        ]
      }</Payload>
        <StatusCode>200</StatusCode>
    </Set>
    <IgnoreUnresolvedVariables>false</IgnoreUnresolvedVariables>
    <DisplayName>AM-SetMakesResponse</DisplayName>
</AssignMessage>
```

2. AssignMessage policy to return car models
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<AssignMessage name="AM-SetModelsResponse">
    <AssignTo createNew="false" type="response"/>
    <Set>
        <Payload contentType="application/json">{ models: [
            { make: "Toyota", name: "Corolla", image: "https://upload.wikimedia.org/wikipedia/commons/9/9e/2018_Toyota_Corolla_%28ZWE211R%29_ZR_hybrid_hatchback_%282018-10-30%29_01.jpg" },
            { make: "Toyota", name: "Camry", image: "https://upload.wikimedia.org/wikipedia/commons/a/ac/2018_Toyota_Camry_%28ASV70R%29_Ascent_sedan_%282018-08-27%29_01.jpg" },
            { make: "Toyota", name: "Tundra", image: "https://upload.wikimedia.org/wikipedia/commons/5/5a/Toyota_Tundra_SR5_Double_Cab_--_12-26-2009.jpg" }
        ]
      }</Payload>
        <StatusCode>200</StatusCode>
    </Set>
    <IgnoreUnresolvedVariables>false</IgnoreUnresolvedVariables>
    <DisplayName>AM-SetModelsResponse</DisplayName>
</AssignMessage>
```

3. Test makes resource of API

```
curl https://my-dummy-org-prod.apigee.net/cars-api/makes
```

Expected Response

```
{ makes: [
            { name: "Toyota", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/2018_Toyota_Prius_c_%28NHP10R%29_hatchback_%282018-10-29%29_01.jpg/220px-2018_Toyota_Prius_c_%28NHP10R%29_hatchback_%282018-10-29%29_01.jpg" },
            { name: "Lexus", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/2017-03-07_Geneva_Motor_Show_1217.JPG/220px-2017-03-07_Geneva_Motor_Show_1217.JPG" }
        ]
      }
```

4. Test models resource of API

```
curl https://my-dummy-org-prod.apigee.net/cars-api/models
```

Expected Response

```
{ models: [
            { make: "Toyota", name: "Corolla", image: "https://upload.wikimedia.org/wikipedia/commons/9/9e/2018_Toyota_Corolla_%28ZWE211R%29_ZR_hybrid_hatchback_%282018-10-30%29_01.jpg" },
            { make: "Toyota", name: "Camry", image: "https://upload.wikimedia.org/wikipedia/commons/a/ac/2018_Toyota_Camry_%28ASV70R%29_Ascent_sedan_%282018-08-27%29_01.jpg" },
            { make: "Toyota", name: "Tundra", image: "https://upload.wikimedia.org/wikipedia/commons/5/5a/Toyota_Tundra_SR5_Double_Cab_--_12-26-2009.jpg" }
        ]
      }
```
