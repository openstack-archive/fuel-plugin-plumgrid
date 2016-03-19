Installation Guide
==================

Prerequisites
-------------

This document assumes that you have `installed Fuel <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html>`_
and setup the target hosts with appropiate networking for the pxe, management, public and plumgrid-fabric networks. The nodes
must be discovered and functional prior to doing the following steps.

Obtain a PLUMgrid ONS license and access to packages or LCM image at info@plumgrid.com

Installing Fuel PLUMgrid Plugin
-------------------------------

#. Clone the Fuel PLUMgrid plugin repository:
   ::

      git clone https://github.com/openstack/fuel-plugin-plumgrid

#. Install Fuel Plugin Builder:
   ::

      pip install fuel-plugin-builder

#. Navigate to the cloned PLUMgrid Fuel plugin folder and build the plugin:
   ::

      cd fuel-plugin-plumgrid/
      fpb --build .

#. The plumgrid-<x.x.x>.rpm plugin file will be created.

#. Copy this file to the Fuel Master node with secure copy (scp):
   ::

      scp plumgrid-<x.x.x>.rpm root@:<the_Fuel_Master_node_IP address>:/tmp

#. On the Fuel Master node, Install the PLUMgrid plugin with:
   ::

      cd /tmp
      fuel plugins --install plumgrid-<x.x.x>.rpm

  You should get the following output
  ::

      Plugin <plugin-name-version>.rpm was successfully installed


#. The plugin is now ready for use and can be enabled on the Settings tab, PLUMgrid Plugin section
   of the Fuel web UI, as explained next.

Configuring PLUmgrid Plugin
---------------------------

#.  In Fuel UI `create environment <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#create-a-new-openstack-environment>`_.

    .. image:: images/create_env.png
       :width: 80%

#.  Select the appropiate KVM or QEMU hypervisor type for your environment.

    .. image:: images/compute.png
       :width: 80%

#.  Select Neutron with VLAN segmentation as Networking Setup.

    .. image:: images/networking_setup.png
       :width: 80%

#.  After creating the enviroment, navigate to Settings → Fuel PLUMgrid plugin. Check the Fuel PLUMgrid Plugin
box and fill in the appropiate values for the your enviroment.

   .. image:: images/plumgrid_ui_setup.png
       :width: 80%


  * Enter the username for PLUMgrid: default is *plumgrid*

  * Enter the password for PLUMgrid: default is *plumgrid*

  * PLUMgrid VIP on the management network to access the PLUMgrid console:  The IP address for PLUMgrid console, make sure to select an unassigned IP on the management network.

  * Enter the PLUMgrid Fabric Network: Enter the network that will be used by PLUMgrid Fabric.

  * Repository for PLUMgrid packages: Enter IP address of a repo hosting PLUMgrid packages such as LCM.

  * Enter the zone name for PLUMgrid LCM: If using an LCM enter the zone name specified during its configuration.

  * Enter the license for PLUMgrid: Enter the PLUMgrid license string provided by PLUMgrid support.

  * Enter the interface(s) to be used by GW: Enter the interfaces that will be used for external connectivity by the PLUMgrid Gateway comma separated for more than one. In this example, interfaces are eth3,eth4.

#. Navigate to Repositories tab and click Add Extra Repo and provide the following PLUMgrid repositories:
   ::

      plumgrid           deb http://<LCM-IP>:81/plumgrid plumgrid <component>       1200
      plumgrid-images    deb http://<LCM-IP>:81/plumgrid-images plumgrid <component>   1250

   .. image:: images/plumgrid_repos.png
       :width: 80%

#. Navigate to the Nodes tab to and click on Add nodes. Assign the unallocated nodes their respective roles. Select the role i.e. Controller/Compute/Storage and select the node which will assume that role. This process must be repeated for each node individually.

   .. image:: images/add_nodes.png
       :width: 80%


  You must have the following roles present on individual nodes:

  * 3 Controllers
  * Atleast 1 Compute
  * Atleast 1 Gateway

   .. image:: images/add_controllers.png
       :width: 80%


#.  Network configuration on nodes.

    Physical servers with two network interfaces are used as Controllers and Computes. A PLUMgrid-Gateway node must have an
    additional 1-2 interfaces for external connectivity (these are specified in the PLUMgrid Settings given above)
    The interfaces configuration is following:

    * First interface is used for PXE network

    * Second interface is used for Public, Management and Storage networks using tagged VLANs. The PLUMgrid fabric is also created here.


   .. image:: images/network_config.png
       :width: 80%

#. Navigate to Networks tab and set the appropiate Network Settings for the Public, Storage and Management Networks. Click Verify Networks
to verify correct configuration.

   .. image:: images/verify_network.png
       :width: 80%


#.  Press **Deploy changes** to `deploy the environment <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#
    deploy-changes>`_.

#. After a succesful deployment. The PLUMgrid UI will be accessible for the VIP entered in the PLUMgrid Settings

   .. image:: images/pg_ui.png
       :width: 80%

