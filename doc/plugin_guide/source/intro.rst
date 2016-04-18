Introduction
============

This document contains instructions for installing and configuring the PLUMgrid plugin for Fuel.
In order to use the PLUMgrid ONS Virtual Network Infrastructure for a Mirantis OpenStack Cloud, follow the Installation Guide.

Key terms, acronyms and abbreviations
-------------------------------------

Given below are some commonly used terms across this document:

+--------------------+-------------------------------------------------------------------+
| PLUMgrid ONS       | PLUMgrid Open Networking Suite (ONS) is a comprehensive software  |
|                    | suite that provides a virtual network infrastructure based on     |
|                    | IO Visor technology.                                              |
+--------------------+-------------------------------------------------------------------+
| VNI                | Virtual Network Infrastructure                                    |
+--------------------+-------------------------------------------------------------------+
| Virtual Domain     | A Virtual Domain is a logical data center. It can be created on   |
|                    | demand to provide all the networking services (e.g. Routers,      |
|                    | Switches, IPAM, DHCP, NAT, etc.) necessary to build a virtual     |
|                    | network for a project in OpenStack. Typically, each OpenStack     |
|                    | project will map to a unique Virtual Domain in the PLUMgrid.      |
+--------------------+-------------------------------------------------------------------+
| Zone               | Represents the physical deployment of PLUMgrid ONS. A Zone is     |
|                    | primarily a collection of Edges & Gateways that are dependent on  |
|                    | the same cluster of Directors in a single physical location. A    |
|                    | data center can have multiple Zones.                              |
+--------------------+-------------------------------------------------------------------+
| Director           | The control plane of PLUMgrid ONS. The configuration of the VNI   |
|                    | for tenants is done through the Director. The PLUMgrid Directors  |
|                    | are typically deployed in a cluster of three nodes to provide high|
|                    | availability and scale. Directors are co-located on the OpenStack |
|                    | Controller nodes.                                                 |
+--------------------+-------------------------------------------------------------------+
| Edge               | An OpenStack Compute node running PLUMgrid IO Visor as a kernel   |
|                    | module. It provides the data plane and network connectivity for   |
|                    | the VMs of OpenStack tenants. Communication for VMs between Edges |
|                    | is enabled by creating overlay tunnels using VXLAN encapsulation  |
+--------------------+-------------------------------------------------------------------+
| Gateway            | Provides connectivity from virtual fabric (VXLAN based) to        |
|                    | external IP networks (such as for internet access). Gateway(s)    |
|                    | can be deployed as a pair in Active/Active mode for load balancing|
|                    | of traffic and high availability of external connectivity.        |
+--------------------+-------------------------------------------------------------------+
| LCM                | The Life Cycle Manager is a VM that is used to host the necessary |
|                    | PLUMgrid packages needed to install (or update) a PLUMgrid Zone.  |
+--------------------+-------------------------------------------------------------------+

The figure below depicts how all these components fit in a PLUMgrid Zone.

    .. image:: images/pg_zone.png
       :width: 80%


Overview
--------

The PLUMgrid plugin for Fuel provides the capability to use PLUMgrid ONS for Mirantis OpenStack as the entire networking backend.
It is configured through the Fuel UI.

PLUMgrid Open Networking Suite (ONS) is a comprehensive software suite that provides terabits of scale out performance, production
grade resiliency, and secure multi-tenancy for hybrid data centers. Built on PLUMgrid Platform and IO Visor technology, the software
suite lets users create private Virtual Domains to provide isolation, security, and policy enforcement across tenants.

PLUMgrid ONS features:

*   Performance: Up to 40 Gbps per server; hardware offload; terabytes of aggregate performance.

*   Scalable: across virtual domains, workloads and multiple racks, geographies.

*   Supports both hardware and software gateways in highly available configurations.

*   Secure: end-to-end encryption within Virtual Domains and isolation across tenants.

*   Operational tools: includes a comprehensive suite of powerful networking, monitoring and troubleshooting tools.

Licensing information
---------------------

+----------------------+-----------------+
| PLUMgrid ONS         | Commercial      |
+----------------------+-----------------+
| Fuel PLUMgrid Plugin | Apache 2.0      |
+----------------------+-----------------+

Contact PLUMgrid for an Installation pack (including Full/Trial License, PLUMgrid Packages, deployment documentation): info@plumgrid.com
