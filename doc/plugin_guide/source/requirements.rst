Requirements
============

In addition to the requirements set by a Mirantis 9.0 Installation. The PLUMgrid plugin also has the following software and hardware requirements:

Network Requirements
--------------------

Nodes within the PLUMgrid Zone are connected using the following two networks:

#. **Management:** This network is mapped onto the Management network (br-mgmt) deployed within a Mirantis OpenStack Environment.

#. **Fabric:** This network is mapped directly onto the tagged/untagged interface deployed within the Mirantis OpenStack Environment. The network cidr is specified through the Fuel UI, as explained later. MTU for the fabric network is set to 1580 (this is the minimum value for PLUMgrid to work correctly, it will also function for higher values).

Node Interface Requirements
+++++++++++++++++++++++++++

Physical servers with two network interfaces are used as Controllers, Computes and A PLUMgrid-Gateways. A PLUMgrid-Gateway node must also have an additional 1-2 interfaces for external connectivity (these are specified in the PLUMgrid Settings given in the install section). The interfaces configuration is the following:

* First interface is used for PXE network.
* Second interface is used for Public, Management and Storage networks using tagged VLANs. The PLUMgrid fabric network is also created here.

  .. image:: images/network_config.png
      :width: 80%


PLUMgrid Repository
-------------------

Access to a url hosting PLUMgrid packages is required before deployment. A common way to obtain this is to use a LCM image to create the LCM VM, which will host the required packages. This VM then becomes the source repo for installing and upgrading PLUMgrid. The VM can typically be created on the Infrastructure Server hosting the Fuel VM. It needs to be provided with management and fabric connectivity. Contact PLUMgrid to obtain an LCM image with pre-baked PLUMgrid packages and a license [info@plumgrid.com].

Node Requirements
-----------------

You must have atleast the following nodes present to set up a minimal deployment:

* 3 Controllers (or 1 Controller for non-HA deployment)
* 1 Compute
* 1 PLUMgrid-Gateway
