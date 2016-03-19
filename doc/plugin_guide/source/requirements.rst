Requirements
============

In addition to the requirements set by a Mirantis 7.0 Installation. The PLUMgrid plugin also has the following requirements
for software and hardware:

Network Requirements
--------------------

Nodes within the PLUMgrid Zone are connected using the following two networks:

#. Management: This network is mapped onto the Management network (br-mgmt) deployed within Mirantis OpenStack Environment.

#. Fabric: This network is mapped directly onto the untagged interface deployed within the Mirantis OpenStack Environment. The
fabric network **cannot be bridged or tagged**, it is automatically created by the Fuel PLUMgrid plugin on the interface being
used by br-mgmt. The network cidr is specified through the Fuel UI, as explained later. MTU for the entire fabric network is set to 1580 (this is the minimum value for PLUMgrid to work correctly, it will also function for higher values).

PLUMgrid Repository
-------------------

Access to a url hosting PLUMgrid packages is required before deployment. A common way to obtain this is to use a LCM image to create
the LCM VM. This VM then becomes the source repo for installing and upgrading PLUMgrid. The VM can typically be created on the
Infrastructure Server hosting the Fuel VM. It needs to be provided with management and fabric connectivity.

