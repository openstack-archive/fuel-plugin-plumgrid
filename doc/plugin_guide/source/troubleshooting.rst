Troubleshooting
===============


#. When PLUMgrid tasks fail during deployment.

   **Solution**

   Determine what node it failed on from the Fuel Astute Logs. Login to that node (SSH through the Fuel Master node),
   and check the logs under /var/log/plumgrid .

#. A node is not visible in the PLUMgrid UI, Zone View > Zone Inventory.

   **Solution**

   Login to that node (SSH through the Fuel Master node) and check PLUMgrid services. Start if stopped:
   ::

      service plumgrid status
      service plumgrid start

Expected Failures
-----------------

#. Some health checks are expected to fail due to the default networks and routers created during the deployment being deleted, after PLUMgrid plugin is installed. These are created before PLUMgrid is enabled as the network backend, hence the PLUMgrid ONS platform has no knowledge of these previously created routers/networks and they are therefore removed.

#. *Check pacemaker status* will also fail on OVS checks, as OVS is not used in a PLUMgrid based environment.

#. Using *fuel createmirror* is not supported since the PLUMgrid plugin requires a specific version of certain packages on trusty that are not hosted by the partial mirror created by this tool. Furthermore, for an enviroment with the PLUMgrid plugin enabled, it will fail to set repositories as defaults for new environments; however it will update the current ones in the Fuel UI Settings --> Repositories to the local links.

#. Removing / Adding Controller nodes are not supported in this plugin version, as they will fail on Create_network task.
