<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="200" alt="Nest Logo" /></a>
</p>

# Producer

**Paso 1: primero instalamos las dependencias necesarias con yarn add:**

- @nestjs/config
- @nestjs/microservices
- amqp-connection-manager
- class-transformer
- joi

**Paso 2: Configuracion del main.ts**

- Se Crea una instancia de la clase AppModule.
- Se Utiliza la instancia creada para crear una aplicación de Nest.js.
- Habilitamos los CORS en la aplicación para permitir peticiones desde otros dominios.
- Configuramos un "global pipe" de validación para validar los datos de las peticiones entrantes. Este pipe tiene las siguientes opciones de configuración:

```
- whitelist: true - Solo permite propiedades que estén explícitamente definidas en las clases DTO (Data Transfer Object).
- forbidNonWhitelisted: true - Rechaza cualquier propiedad que no esté definida en las clases DTO.
- transform: true - Aplica automáticamente transformaciones a los datos de entrada según los tipos definidos en las clases DTO.
- transformOptions - Opciones adicionales para las transformaciones automáticas. En este caso, se habilita la conversión implícita de tipos.
- Se inicia la aplicación y se pone a la escucha en el puerto especificado en la configuración de variables de entorno (EnvConfiguration().port).
- Imprimimimos en la consola la URL del servidor una vez que esté listo para recibir peticiones.
```

**Paso 3: Configuracion del app.module.ts**

- En la sección imports, se importa el módulo ConfigModule de Nest.js y se configura para ser utilizado en todo el módulo.

- Se establecen las siguientes opciones de configuración:

```
- isGlobal: true - Indica que este módulo es global y sus configuraciones estarán disponibles en todo el proyecto.
- load: [EnvConfiguration] - Carga la configuración de variables de entorno utilizando la función EnvConfiguration del archivo env.config.ts.
- validationSchema - Define un esquema de validación utilizando Joi para las variables de entorno. En este caso, se define que PORT debe ser un número requerido y RABBITMQ_URL debe ser una cadena requerida.
```

- En la sección ClientsModule.register, se registra un cliente de microservicio utilizando el módulo ClientsModule de Nest.js. Se establecen las siguientes opciones de configuración:

```
- name: 'USERS_SERVICE' - Nombre del cliente de microservicio.
- transport: Transport.RMQ - Indica que el transporte utilizado será RabbitMQ.
- options - Opciones de configuración específicas para RabbitMQ. Se establecen las siguientes opciones:
- urls: [EnvConfiguration().rabbitMqUrl] - URL(s) de RabbitMQ obtenidas de la configuración de variables de entorno.
- queue: 'users_queue' - Nombre de la cola de RabbitMQ a la que se conectará el cliente de microservicio.
- queueOptions - Opciones adicionales para la cola de RabbitMQ. En este caso, se establece durable: false para que la cola no sea durable.
```

**Paso 4: Creacion de los endpoints en el app.controller.ts**


- En el constructor de la clase, se inyecta una instancia de AppService mediante la utilización del decorador private readonly appService: AppService. Esto permite que el controlador tenga acceso a los métodos y funcionalidades proporcionados por la clase AppService.
- Se define un método de tipo @Post(), que indica que este método manejará las solicitudes HTTP POST. El método se llama createUser y toma un parámetro createUserDto del tipo CreateUserDto. 
- El decorador @Body() indica que los datos del cuerpo de la solicitud se deben asignar automáticamente al parámetro createUserDto. Dentro del método, se llama al método createUser de appService y se pasa el objeto createUserDto como argumento. El resultado de este método se devuelve como respuesta HTTP.
- Se define un método de tipo @Get(), que indica que este método manejará las solicitudes HTTP GET. El método se llama findAll y no toma ningún parámetro. Dentro del método, se llama al método findAll de appService. El resultado de este método se devuelve como respuesta HTTP.

**Paso 5: Creacion de los services en el app.services.ts**

- En el constructor de la clase, se utiliza el decorador @Inject('USERS_SERVICE') para inyectar un cliente de microservicio en la variable client. El parámetro 'USERS_SERVICE' indica el nombre del cliente de microservicio que se registró en el módulo.
- Se define un método llamado createUser que toma un parámetro user del tipo CreateUserDto. Dentro del método, se utiliza la variable client para enviar un mensaje al cliente de microservicio con { cmd: 'create_user' } como comando y user como datos. El resultado de este mensaje se devuelve como respuesta.
- Se define un método llamado findAll que no toma ningún parámetro. Dentro del método, se utiliza la variable client para enviar un mensaje al cliente de microservicio con { cmd: 'get_all_users' } como comando y un objeto vacío {} como datos. El resultado de este mensaje se devuelve como respuesta.
