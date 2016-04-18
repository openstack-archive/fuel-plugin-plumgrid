Troubleshootig
==============


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
  
