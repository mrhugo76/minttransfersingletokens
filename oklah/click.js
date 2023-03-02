var button = document.querySelector('button.ant-switch-checked');
button.click();

var iframe = document.getElementById('myIframe').contentWindow;

iframe.addEventListener('load', function() {
  var iframeButton = iframe.document.querySelector('button.ant-switch-checked');
  iframeButton.click();
});
