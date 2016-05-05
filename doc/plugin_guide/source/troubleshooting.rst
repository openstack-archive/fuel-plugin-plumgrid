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
