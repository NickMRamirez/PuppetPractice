class profiles::iis {
  windowsfeature { 'IIS':
    ensure       => present,
    feature_name => [
      'Web-Server',
      'Web-WebServer',
      'Web-Common-Http',
      'Web-Default-Doc',
      'Web-Dir-Browsing',
      'Web-Http-Errors',
      'Web-Static-Content',
      'Web-Health',
      'Web-Http-Logging',
      'Web-Http-Tracing',
      'Web-Performance',
      'Web-Stat-Compression',
      'Web-Dyn-Compression',
      'Web-Security',
      'Web-Filtering',
      'Web-App-Dev',
      'Web-Net-Ext',
      'Web-Net-Ext45',
      'Web-Asp-Net',
      'Web-Asp-Net45',
      'Web-ISAPI-Ext',
      'Web-ISAPI-Filter',
      'Web-Mgmt-Tools',
      'Web-Mgmt-Console',
     ]
  }
}