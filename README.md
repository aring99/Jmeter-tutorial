# Jmeter-tutorial
This repo shows how to make and run Jmeter in distributed mode (Master-slave).
For this tutorial, Java version 21 and Jmeter 5.6.3 was used. To keep it simple, one Linux machine has been used as the master and one windows machine was used as a slave machine.


## Prerequisites:
1. same version of Java needs to be installed on all machines.
2. same version of Jmeter needs to be installed on all machines.


 ## Setting up the Slave Machine(s)


## Script

A script is provided for setting up Jmeter on Linux machines with Java 21, Jmeter 5.6.3 and also runs the jmeter server automatically.
The steps on the script can be reproduced manually if you want to set up a linux slave machine manually. In this document, the steps for setting up a windows slave machine have been documented.

## Setting up Slave Machines on Windows
 1. Before anything is done, take a note of the slave machine's private IP address. The master machine will need it.
 2. First, navigate to the folder where Jmeter is installed and open the bin folder.
<img width="793" height="986" alt="image" src="https://github.com/user-attachments/assets/4e5eaa1b-c4ec-42df-b76e-0185ef4b11c5" />


 3. Afterwards open "jmeter.properties" with a text editor as highlighted in the image above.
 
 4. Then search for "# Set this if you don't want to use SSL for RMI". When you do, you can see the following commented out line "server.rmi.ssl.disable=false".
Normally, you need to have SSL certifactes on both the slave machine and the Master machine, but to keep it simple we are going disable it for learning and testing purposes.

So the next step is to uncomment it and set it to true like in the image below (server.rmi.ssl.disable=true):
<img width="410" height="36" alt="image" src="https://github.com/user-attachments/assets/1331b852-82dc-4009-9570-c96a06524e1f" />

Then save and close the file.

 5. The final step is to run Jmeter on the slave machine, on a windows machine you have to run the "jmeter-server.bat" as shown in the image below

    <img width="720" height="564" alt="image" src="https://github.com/user-attachments/assets/fb849b6e-1ac3-4943-9fbb-9d0707b7d3bf" />

After running it, you should have a terminal open and we can monitor the slave machine from there.


 ## Setting up the Master MachineScreenshot from 2026-06-26 12-04-38
1. Similar to the Slave machine, we navigate to the bin folder under Jmeter and open the file "jmeter.properties." with a text editor:Thread GroThread Groupuseupuse

<img width="636" height="324" alt="image" src="https://github.com/user-attachments/assets/8bf506b1-c013-4836-8765-e25e751e180d" />


2. Afterwards we disable the SSL certifaction requirement just like in step 4 in Slave Machines.

<img width="394" height="38" alt="image" src="https://github.com/user-attachments/assets/afd409df-da45-4cb8-b4df-f2262334f27c" />

There is an additional step for the master, search "remote_hosts" and add the private ip of the slave machines, seperated with ","; as shown below.

<img width="338" height="35" alt="image" src="https://github.com/user-attachments/assets/0c0e7093-e25a-44df-ad30-7b1ace4be8fc" />

3. Now the final step is to run Jmeter on the Master machine, too. Since this machine is a Linux machine, we run the command "sh jmeter.sh", this should open up the GUI.

## Running a remote test

1. To run a basic test we need 3 components. A thread group, a sampler and a listener. The thread group will represent the users sending the request, the sampler will send a HTTP Request and the listener will show the results.
2. Rightclicking on "Test Plan" will open a drop down list, you can hover over "Add" then "Threads" and finally click on "Create Thread Group". You can rename the created thread group if you wish, but you will see that the thread group with a gear sign is now created under the "Test Plan". This time rightclick on the gear, then hover over "Add" then "Sampler" and finally click on HTTP Request.

<img width="1536" height="364" alt="image" src="https://github.com/user-attachments/assets/f36cecf6-121a-4547-91dc-f5f760241298" />

In this case, we are sending a request to the google home page.
3. Afterwards we add a Listener by rightclicking the HTTP Request, hover over "Add" and then hover over "Listener". You can click on any of the listed views.

4. Here is the final part. We save this test plan and then click on "Run" on the top of the GUI. What we will do is hover over "Remote Start" and click on the IP of our Slave machine, alternatively click on "Remote Start All" to run for all Slave machines.
<img width="389" height="207" alt="image" src="https://github.com/user-attachments/assets/0d35351e-1b2e-44bd-9912-5836fa8b639c" />

5. After that we can see on the slave machine terminal that it has received and executed the test.
<img width="647" height="45" alt="image" src="https://github.com/user-attachments/assets/69ec5e71-e20e-49dd-ad18-a5c55a58f362" />

6. On the Master machine we can see the result of this test:
<img width="607" height="420" alt="image" src="https://github.com/user-attachments/assets/ed86d803-a53e-438d-a881-069573a9d362" />


## Troubleshooting

If the results above couldn't be reached, 
1. First make sure if the Java and Jmeter versions are the same.
2. Make sure if the SSL has been disabled on both machines and check if the ip added on the Master machine is correct.
3. Ping the machines from each other to see if they can communicate with each other. If not, there might be a firewall blocking the communication.
