# gossip-push-sum-protocol

Authors

Shikha Mehta (UF ID 4851 9256)
Aniketh Sukhtankar (UF ID 7819 9584)
-------------------------------------------------------
 DISTRIBUTED OPERATING SYSTEM - GOSSIP SIMULATOR 
-------------------------------------------------------

CONTENTS OF THIS FILE 
---------------------
   
 * Required Answers  
 * Introduction
 * Requirements
 * Installation and Configuration
 * Program flow
 * Developer information


REQUIRED ANSWERS
----------------
* Team members

  Shikha Mehta (UF ID 4851 9256)
  
  Aniketh Sukhtankar (UF ID 7819 9584)

* What is working

  - 100% convergence is being achieved each time for Gossip in all the topologies. The upper limit for the number of nodes that can be handled by the system is only due to the system limits on the number of processes.
  - 'Line' topology takes a large time to converege for gossip and push sum while 2d takes over line for large networks. 
  - Moreover, Gossip is working for Full, 2D and Imperfect 2D for nodes upto 80000 without hitting system limits and converges better than line.
  - Pushsum took much longer to converge when compared to gossip as the sum from one end of the network had to reach the other end of the network which was not pssobile in many cases (large networks and line topology). Deadlocks were encountered while running push sum for line topology and large nodes,
  - In conclusion, All the Topologies have been implemented for both Push Sum and Gossip algorithm. I have also implemented a failure model and tested it with multiple parameters (Number of killed nodes, Number of nodes triggered at initiation and Conergence criteria). I have tested the failure model on all the topologies as well as both Push Sum and Gossip algorithms.
  - The advantages of the gossip algorithms are that they are completely decentralized, have excellent fault tolerance, are Iterative and probabilistic which makes them imperfect. The algorithms run fast in certain scenarios and slow in others. The Push Sum algorithm is good for computing sum and can be extended to compute many types of linear functions, random sampling, quantiles, etc.


* What is the largest network you managed to deal with for each type of topology and algorithm

               | FULL          | IMP 2D        | 2D            | LINE        |
 GOSSIP        | 80000 nodes   | 80000 nodes   | 130000 nodes  | 130000 nodes|
 PUSHSUM       | 130000 nodes  | 130000 nodes  | 120000 nodes  | 130000 nodes|   

 Trying larger than the above values led to the following error 19:44:59.632 [error] Too many processes

INTRODUCTION
------------
The project folder contains 2 folders:

* gossip: Contains the folders related to the gossip simulator project. Important files being:
          - Main.ex
          - Implementation.ex
	  - Gossip and Push Sum Actors
          - report.pdf

* bonus: Contains the folders related to the bonus project.
         - Main.ex
         - Implementation.ex
	 - Gossip and Push Sum Actors
         - bonus-report.pdf



REQUIREMENTS
------------
The following need to be installed to run the project:
* Elixir
* Erlang

INSTALLATION AND CONFIGURATION
------------------------------
 Go to the folder 'project2' using command line tool and type escript project2 numnodes topology algorithm.


PROGRAM FLOW
------------
* GOSSIP
  - enter the number of nodes (will be rounded up for 2d and imp2d topologies)
  - enter the topology
  - enter the algorithm
  - (optional) enter the number of nodes triggered at initiation
  - (optional) enter the stopping criteria (eg. 100 if there are a 1000 nodes in the network and a convergence rate of 90% i.e. 900 nodes converging is good enough)

* BONUS
  - enter the number of nodes (will be rounded up for 2d and imp2d topologies)
  - enter the topology
  - enter the algorithm
  - enter the number of nodes to kill (used this feature for testing and analyzing various topologies and algorithms)
  - (optional) enter the number of nodes triggered at initiation
  - (optional) enter the stopping criteria (eg. 100 if there are a 1000 nodes in the network and a convergence rate of 90% i.e. 900 nodes converging is good enough)


DEVELOPER INFORMATION
---------------------

  Aniketh Sukhtankar (UF ID 7819 9584) asukhtankar@ufl.edu
  
  Shikha Mehta (UF ID 4851 9256) shikha.mehta@ufl.edu
