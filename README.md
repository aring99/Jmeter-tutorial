# Jmeter-tutorial
This repo shows how to make and run Jmeter in distributed mode (Master-slave).
For this tutorial, Java version 21 and Jmeter 5.6.3 was used. To keep it simple, one Linux machine has been used as the master and one windows machine was used as a slave machine.


## Prerequisites:
1. same version of Java needs to be installed on all machines.
2. same version of Jmeter needs to be installed on all machines.


 ## Setting up the Slave Machine(s)

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


 ## Setting up the Master Machine
