## Task-10

- Zadatak 10 za 12. sedmicu predavanja DevOps Mentorship programa bio je da kompletiramo sljedece lekcije iz kursa AWS Certified Solutions Architect - Associate (SAA-C03).
- Navedene lekcije sadrze teorijski i prakticni dio. Sve lekcije koje su oznacene kao DEMO reproducirao sam unutar svog AWS racuna.

#### Lekcije:

- [x] Architecture Deep Dive Part 1
- [x] Architecture Deep Dive Part 2
- [x] AWS Lambda Part 1
- [x] AWS Lambda Part 2
- [x] AWS Lambda Part 3
- [x] CludWatchEvents and Event Bridge
- [x] Automated EC2 Control using lambda and events Part 1 (DEMO)
- [x] Automated EC2 Control using lambda and events Part 2 (DEMO)
- [x] Serverless Architecture
- [x] Simple Notification Service (SNS)
- [x] Step Functions
- [x] API Gateway 101
- [x] Build a serverless app part 1
- [x] Build a serverless app part 2
- [x] Build a serverless app part 3
- [x] Build a serverless app part 4
- [x] Build a serverless app part 5
- [x] Build a serverless app part 6
- [x] Simple Queue Service (SQS)
- [x] SQS Stadanard vs FIFO Queus
- [x] SQS Delay Queues

- Nakon kompletiranih lekcija napravio sam komentar na tiketu koji sadrzi Pull Request sa mojim zabiljeskama iz lekcija i kodom koji sam koristio, sve zabiljeske su unutar `README.MD` fajla, dok su kod i screenshot-i unutar zasebnih direktorija.

### 1 ARCHITECTURE DEEP DIVE - PT 1

#### Event-Driven Architecture 
- WHY do we need to understand EDA?
	- As a solutions architect we need to design a solution using a specific architecture around a given set of business requirements. We need to have a good base level understanding of all the different types of architectures available to us in AWS. 
	- We cannot build something unless we fully understand the architectures. 

#### Monolithic Architecture
- Historically, the most popular systems architecture was known as a Monolithic Architecture. 
	- We can think of it as a single black box with all of the components of the application within it. 
	- Components: Upload, Processing, Store and manage.
	- Things to keep in mind with MA:
		- Because it's all one entity it fails together as an entity - if one component fails it impacts the whole thing end to end.
		- Monoliths also scale together, they are highly coupled - all components on the same server directly connected and have the same codebase, cannot scale one without the other.
		- With MA we need to vertically scale the system because everything expects to be running on the same piece of compute hardware. 
		- They generally bill together - always running and always incur charges even if the processing engine is doing nothing, no videos are being uploaded, the system capacity has to be enough to run all of them so they always have allocated resources even if they arent consuming them.
- That is the reason why using the MA tends to be least cost-effective way to architect systems. 
- ![monolithic-arhitecture](../week-12/screenshots/slika-1.png)

#### Tiered Architecture
- We can evolve Monolithic Architecture to Tiered Architecture where monolith is broken apart and we have a collection of different tiers and each of them can be on different servers, or all of them on the same server.
- Benefits:
	- Individual tiers can be vertically scaled independently.
	- Instead of each tier directly connecting to each other we can utilize load balancers located between each of the tiers. 
	- Usage of load balancers allows for horizontal scaling (when it comes to Processing), meaning additional processing tier instances can be added. Communication occurs via the load balancers so the upload and store, and manage tiers have no exposure to the architecture of the Processing tier. 
- This architecture is imperfect for two main reasons:
	- The tiers are still coupled. Upload expects and requires processing tier to respond.
	- Even if there's no jobs to be processed, the processing tier has to have something running - otherwise there will be failure when the upload tier attempts to add an upload job.
- ![tiered-arhitecture](../week-12/screenshots/slika-2.png)

### 2 ARCHITECTURE DEEP DIVE - PT 2

#### Evolving with Queues

- A queue is a system that accepts messages that ascend onto it and can be received or pulled off the queue. 
- Messages are received of the queue in a FIFO (First In, First Out) architecture - but it's worth noting that this isn't always the case. 
- How does this work in a background? Adrian gives example using CatTube app:
	- User uploads video to the `upload` component.
	- Once the upload is complete, instead of passing this directly onto the processing tier, it'll do something slightly different - it stores the video inside an S3 bucket and adds a message to the queue detailing where the video is located as well as any other relevant information such as what sizes are required.
	- This message, because it's the first one in the queue is architecturally at the front of the queue.
	- At this point the `upload tier` because it has uploaded the master video to S3 and added a message to the queue has finished this particular transaction. It doesn't talk directly to the processing tier and it doesn't know or care if it's actually functioning. The key thing is that the `upload tier` doesn't expect an immediate answer from the `processing tier`.
	- The queue has decoupled the upload and processing components. It uses the async communications where the `upload tier` sends the message and it can either wait in the background or just continue doing other things while the `processing tier` does its job.
	- While this process is going on, the upload component is probably getting additional videos being uploaded and they are added to the queue along with the first video processing job and all the messages that are added to the queue are behind this first video processing job because of the FIFO order. 
- On the other side of the queue we have an Auto Scaling Group which is being configured and contains Auto Scaling policies which provision or terminate instances based on the queue length - which is the number of items in the queue. 
- ![evolving-with-queues](../week-12/screenshots/slika-3.png)
- Because there are messages in the queue added by the `upload tier`, the Auto Scaling group detects this and the desired capacity is increased from zero to two - which leads to instances being provisioned by the Auto Scaling group, and these instances start pulling the queue and receive messages that are at the front of the queue. These messages contain data for the job but they also contain the location of the S3 bucket and the location of the object in that bucket. 
- So, once these jobs are received from the queue, by these processing instances, they can also retrieve the master video from the S3 bucket.
- Now, these jobs are processed by the instances and then they're deleted from the queue and this leaves only one job in the queue.
- ![evolving-with-queues-2](../week-12/screenshots/slika-4.png)
- At this point maybe ASG decides to scale back because of the shorter queue length, so it reduces the desired capacity from two to one which terminates one of the processing instances. The instance that remains pulls the queue and receives the one final message and it leaves zero messages in the queue.
- ![evolving-with-queues-3](../week-12/screenshots/slika-5.png)
- The ASG realizes this and scales back the desired capacity from 1 to 0 which results in termination of the last instance.

- HOW this works?
- Using a queue architecture by placing a queue in between two applications tiers, decouples those tiers. One tier adds jobs to the queue and it doesn't care about the health or the state of the other and another tier can read jobs from that queue and it doesn't care how they got there.
- By using the queue architecture, no communication happens directly. The components are decoupled, the components can scale independently and freely and in this case the processing tier which uses a worker-fleet architecture, it can scale anywhere from zero to a near infinite number.

#### Microservice architecture

- The microservice architecture is a collection of microservices - that do individual things very well, for example - process, upload, store and manage microservices.

#### Event Driven Architecture

- Event-Driven Architectures are just a collection of events producers which might be components of your application which directly interact with customers or they might be parts of your infrastructure such as EC2, or they might be systems monitoring components. 
- They're bits of software which generate or produce events in reaction to something - example, if a customer clicks submit, that might be an event. 
- Producers are things which produce events and the inverse of this are consumers - pieces of software which are ready and waiting for events to occur.
- If they see an event which they care about they will do something with that event. 
- The key thing to understand about Event-Driven Architectures is that neither producers nor consumers are sat around waiting for things to occur. With producers, events are generated when something happens - like when button is clicked, when an upload works or it does not work. These producers produce events, consumers are not waiting around for those events, they have those events delivered and when they receive an event, they take an action and then they stop. They're not constantly consuming resources.
- Best practice Event-Driven Architectures have what's called an Event Router - a highly available, central exchange point for events. 
- Event Router has what's known as an event bus and you can think of this like a constant flow of information. 
- When events are generated by producers, they're added to this event bus and the router can deliver these to event customers. 
- ![Event-Driven-Architecture](../week-12/screenshots/slika-6.png)
- To summarize - at Event-Driven Architecture:
	- No constant running or waiting for things.
	- Producers generate events when something happens.
	- Clicks, errors, criteria met, uploads, actions - all generate event.
	- Events are delivered to consumers.
	- After that actions are taken & the system returns to waiting.
	- Mature event-driven architecture only consumes resources while handling events (serverless). 

### 3 AWS LAMBDA - PART 1

- Lambda is a FaaS (Function-as-a-Service) - short running and focused.
- Lambda function - a piece of code lambda runs.
- Functions use a runtime (example - Python 3.8)
- Functions are loaded and run in a runtime environment.
- The environment has a direct memory (indirect CPU) allocation.
- You are billed for the duration that a function runs.
- A key part of Serverless architectures.

- HOW it works:
	- Your Lambda function, at its most basic, is a deployment package which Lambda executes. So when you create a Lambda function, you define the language which the function is written in, you provide Lambda with a deployment package, and you set some resources, and whenever the Lambda function is invoked, what actually happens is the deployment package is downloaded and executed within this runtime environment.
	- Lambda supports lots of different runtimes (Common Runtimes: Python, Ruby, Java, Go, C#). 
	- We can also create custom runtimes using Lambda layers and many of them are created by the community. 
	- One really important point for the exam is that if we see or hear the term Docker, consider this to to mean not Lambda because Docker is an anti-pattern for Lambda. 
- Term Docker in exam refers to traditional containerized computing - using a specific Docker image to spin up a container and use it in a containerized compute environment such as ECS. 
- Now you can also use container images with Lambda - but that's a different process, which means that we are using our existing container build processes, the same ones that we use to create Docker images.
- It's also important to note that we directly control the memory allocated for Lambda functions whereas vCPU is allocated indirectly.
- Lambda functions can run up to 900 seconds or 15 minutes.
- ![aws-lambda-part-1](../week-12/screenshots/slika-7.png)
- Common uses of Lambda:
	- Serverless Applications (S3, API Gateway, Lambda)
	- File processing (S3, S3 Events, Lambda)
	- Database Triggers (DynamoDB, Streams, Lambda)
	- Serverless CRON (EventBridge/CWEvents + Lambda)
	- Realtime Stream Data Processing (Kinesis + Lambda)

### 4 AWS LAMBDA - PART 2

- Lambda has two networking modes: Public (which is default) and then we have VPC networking.  

- Lambda public networking - by default lambda functions are given public networking. They can access public AWS services and the public internet. 
- Public networking offers the best performance because no customer specific VPC networking is required.  
- ![aws-lambda-part-2-public](../week-12/screenshots/slika-8.png)

- Lambda private networking - Lambda functions running in a VPC obey all VPC networking rules.
- If we want VPC Lambdas to access internet resources we would have to deploy NatGW and Internet Gateway.
- We also need to assign EC2 network permissions. 
- ![aws-lambda-part-2-private](../week-12/screenshots/slika-9.png)
- Security - Lambda execution roles are IAM roles attached to lambda functions which control the permissions the Lambda function receives.
- Lambda resource policy controls WHAT services and accounts can INVOKE lambda functions.
- ![aws-lambda-part-2-security](../week-12/screenshots/slika-10.png)
- Logging
	- Lambda uses CloudWatch, CloudWatch Logs & X-Ray
	- Logs from Lambda executions - CloudWatchLogs
	- Metrics - invocation success / failure, retries, latency stored in CloudWatch.
	- Lambda can be integrated with X-Ray for distributed tracing. 
	- CloudWatch Logs requires permissions via Execution Role.

### 5 AWS LAMBDA - PART 3

#### Invocation - three different methods:
	
- Synchronous invocation
- Asynchronous invocation
- Event Source mappings
	
#### Synchronous invocation:

- CLI/API invoke a lambda function, passing in data and wait for a response.
- Lambda function responds with data or fails.

![Synchronous-invocation](../week-12/screenshots/slika-11.png)

#### Asynchronous invocation
	
- Typically used when AWS services invoke lambda functions.
- example with S3 below.

![Asynchronous-invocation](../week-12/screenshots/slika-12.png)

#### Event Source mappings

![Event-Source-mappings](../week-12/screenshots/slika-13.png)

#### Lambda Versions
	
- Lambda functions have versions - v1, v2, v3 etc.
- A version is the code + the configuration of the lambda function.
- It's immutable - it never changes once published & has its own `arn` - Amazon Resource Name.
- $Latest points at the latest version.
- Aliases (DEV, STAGE, PROD) point at a version - can be changed.

#### How Lambda functions are actually executed? 
	
![aws-lambda-execution](../week-12/screenshots/slika-14.png)

### 6 CloudWatchEvents and EventBridge

![CloudWatchEvents](../week-12/screenshots/slika-15.png)

![EventBridge](../week-12/screenshots/slika-16.png)

### 7 Automated EC2 Control using Lambda and Events - DEMO

- I reproduced this scenario on my own AWS account, you can find the screenshots below.
- First I created 2 EC2 instances and a number of Lambda functions that interacted with those instances in a number of ways. 
- One Lambda function stopped those instances, the another started and third one was used to protect EC2 instances in a way that it'll protect them against instance stops. If an instance is moved into a stopped state, it's going to start it up again. 

#### EC2 Instance Stop

![ec2-instance-stop](../week-12/screenshots/slika-1-demo.png)

#### Successful test

![successful-test](../week-12/screenshots/slika-2-demo.png)

#### Instances stopped

![Instances-stopped](../week-12/screenshots/slika-3-demo.png)

#### EC2 Instance Start

![EC2-Instance-Start](../week-12/screenshots/slika-4-demo.png)

#### Successful test

![Successful-test](../week-12/screenshots/slika-5-demo.png)

#### Instances running

![instance-running](../week-12/screenshots/slika-6-demo.png)

#### EC2 Protected Instance

- Rule creation

![rule-creation](../week-12/screenshots/slika-7-demo.png)

- When EC2 instance (instance1) was stopped, after several seconds it moved to Pending state and then Running again.

![ec2-changing states1](../week-12/screenshots/slika-8-demo.png)

![ec2-changing states2](../week-12/screenshots/slika-9-demo.png)

![ec2-changing states3](../week-12/screenshots/slika-10-demo.png)

#### Logs inside CloudWatch:

![logs-cloudwatch](../week-12/screenshots/slika-11-demo.png)

#### Log event for EC2 Protected Instance:

![logs-for-ec2-protected-instance](../week-12/screenshots/slika-12-demo.png)

#### Rule that will stop all EC2 instances on our account - created in Amazon EventBridge:

![rule-in-amazon-eventbridge](../week-12/screenshots/slika-13-demo.png)

### 8 Serverless Architecture

![Serverless-Architecture](../week-12/screenshots/slika-17.png)

#### Serverless Architecture Diagram Example:

![serverless-diagram](../week-12/screenshots/slika-18.png)

### 9 Simple Notification Service

![sns-1](../week-12/screenshots/slika-19.png)

![sns-2](../week-12/screenshots/slika-20.png)

- Delivery Status - including HTTP, Lambda, SQS
- Delivery Retries - reliable delivery.
- HA and Scalable (region)
- Server Side Encryption (SSE)
- Cross-Account via TOPIC Policy

### 10 Step Functions

#### To understand why Step Functions exist, we need to look at some of the problems with Lambda that it addresses.

![problems-with-lambda](../week-12/screenshots/slika-21.png)

#### Step functions as a service allow us to create State Machines

![state-machine](../week-12/screenshots/slika-22.png)

#### States - what kind of states we have?

![machine-states](../week-12/screenshots/slika-23.png)

#### How step functions work - diagram:

![state-function-diagram](../week-12/screenshots/slika-24.png)

### 11 API Gateway 101

- API Gateway is a managed service from AWS which allows the creation of API Endpoints, Resources & Methods.
- The API gateway integrates with other AWS services - and can even access some without the need for dedicated compute.
- It serves as a core component of many serverless architectures using Lambda as event-driven and on-demand backing for methods.
- It can also connect to legacy monolithic applications and act as a stable API endpoint during an evolution from a monolith to microservices and potentially through to serverless.

- https://docs.aws.amazon.com/apigateway/latest/api/CommonErrors.html

![api-gateway](../week-12/screenshots/slika-25.png)

#### General overview and how it works:

![api-gateway-2](../week-12/screenshots/slika-26.png)

#### API Gateway - Authentication

![api-gateway-3](../week-12/screenshots/slika-27.png)

#### API Gateweay - Endpoint types

![api-gateway-4](../week-12/screenshots/slika-28.png)

#### API Gateway - Stages

![api-gateway-5](../week-12/screenshots/slika-29.png)

#### API Gateway - ERRORS

![api-gateway-6](../week-12/screenshots/slika-30.png)

#### API Gateway - Caching

![api-gateway-7](../week-12/screenshots/slika-31.png)

### 12 Pet-Cuddle-o-Tron PART1

#### This advanced demo consists of 6 stages :-
- STAGE 1 : Configure Simple Email service & SNS 
- STAGE 2 : Add a email lambda function to use SES to send emails for the serverless application
- STAGE 3 : Implement and configure the state machine, the core of the application
- STAGE 4 : Implement the API Gateway, API and supporting lambda function
- STAGE 5 : Implement the static frontend application and test functionality
- STAGE 6 : Cleanup the account

- The focus of the first part is SES (Simple Email Service) Configuration. 
	- We need 2 different email addresses (where reminders will be sent from and received to).
	- The address that the emails will be coming from is `vedad.nuhic@edu.fit.ba`
	- The address that the emails will be coming to is `vedad_nuhic@yahoo.com`

![pet-cuddle-o-tron-app](../week-12/screenshots/slika-32.png)

#### Verified emails (identities) at SES:

![verified-emails](../week-12/screenshots/slika-1-demo2.png)

### 13 Pet-Cuddle-o-Tron PART2

- In this _Advanced Demo_ you will be implementing a serverless reminder application.
- The application will load from an S3 bucket and run in browser
- communicating with Lambda and Step functions via an API Gateway Endpoint
- Using the application you will be able to configure reminders for 'pet cuddles' to be sent using email.

#### Creating IAM role that will be assumed by our Lambda functions - we will use CloudFormation template to do this for us.

![iam-role-for-lambda](../week-12/screenshots/slika-2-demo2.png)

#### Lambda role that was created:

![lambda-role-that-was-created](../week-12/screenshots/slika-3-demo2.png)

#### Creating email reminder AWS Lambda function:

![email-reminder](../week-12/screenshots/slika-4-demo2.png)

### 14 Pet-Cuddle-o-Tron PART3

#### In this part we will be adding State Machine that will be configured to use SES via the Lambda function created in Stage 2.

![petcuddleotron-part3](../week-12/screenshots/slika-33.png)

#### Creating role for the State Machine by using CloudFormation stack:

![cloudformation-stack](../week-12/screenshots/slika-1-demo3.png)

#### Overview of what StateMachine does:

![statemachine-overview](../week-12/screenshots/slika-2-demo3.png)

#### StateMachine successfully created:

![statemachine-creation](../week-12/screenshots/slika-3-demo3.png)

### 15 Pet-Cuddle-o-Tron Part4

#### We will be adding API Gateway - creating API itself and a Lambda function which provides compute required to service that API:
![api-gateway-creation-1](../week-12/screenshots/slika-34.png)

#### Creating a Lambda function:
![api-gateway-creation-2](../week-12/screenshots/slika-1-demo4.png)

#### Creating REST API:
![api-gateway-creation-3](../week-12/screenshots/slika-2-demo4.png)

#### Creating Resource in API:
![api-gateway-creation-4](../week-12/screenshots/slika-3-demo4.png)

#### Creating a Method and a POST Method in API Gateway:
![api-gateway-creation-5](../week-12/screenshots/slika-4-demo4.png)
![api-gateway-creation-6](../week-12/screenshots/slika-5-demo4.png)

#### The final step is to deploy API by clicking on Actions - Deploy API and we should see the invoke URL that client application uses. 

### 16 Pet-Cuddle-o-Tron Part5

![petcuddleotron-app](../week-12/screenshots/slika-35.png)

#### Creating S3 bucket and adding front-end files:
![creating-s3-bucket](../week-12/screenshots/slika-1-demo5.png)

#### app test:
![app-test](../week-12/screenshots/slika-2-demo5.png)

### 17 Pet-Cuddle-o-Tron Part6

#### Cleaning out the account and return it to same state as it was at the start of demo series.

### 18 Simple Queue Service

- SQS queues are a managed message queue service in AWS which help to decouple application components, allow Asynchronous messaging or the implementation of worker pools.
- Public, Fully Managed, Highly-Available Queues - Standard or FIFO.
- Messages up to 256KB in size - link to large data.
- Received messages are hidden (VisibilityTimeout).
- ... then either reappear (retry) or are explicitly deleted.
- Dead-Letter queues can be used for problem messages.
- ASGs can scale and Lambdas invoke based on queue length.

#### Example:
![sqs](../week-12/screenshots/slika-36.png)

#### SNS and SQS Fanout example:
- ![sns-sqs](../week-12/screenshots/slika-37.png)

#### Differences between Standard and FIFO queues:
- Standard = at-least-once delivery, FIFO = exactly-once delivery, messages in order first-in, first-out.
- FIFO (Performance) 3.000 messages per second with batching, or up to 300 messages per second without.
- Billed based on 'requests'.
- 1 request = 1-10 messages up to 64KB total.
- Short (immediate) vs Long (waitTimeSeconds) Polling.
- Encryption at rest (KMS) & in-transit.
- Queue policy.

### 19 SQS Standard vs FIFO Queues

#### This lesson reviews the differences between Standard SQS Queues and First-In-First-Out (FIFO) SQS Queues
![sqs-vs-fifo](../week-12/screenshots/slika-38.png)

### 20 SQS Delay Queues

- Delay queues provide an initial period of invisibility for messages. Predefine periods can ensure that processing of messages doesn't begin until this period has expired.

#### How it works:
- ![sqs-delay-queues](../week-12/screenshots/slika-39.png)

