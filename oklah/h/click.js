var iframe = document.getElementById('myIframe').contentWindow;

    iframe.addEventListener('load', function() {
      var iframeButton = iframe.document.querySelector('button.ant-switch-checked');
      if (iframeButton) {
        iframeButton.click();
      } else {
        console.log('无法找到按钮！');
      }
    });
