def confirm_dialog
  page.driver.browser.switch_to.alert.accept
  sleep 0.5
end
