require "selenium-webdriver"
require "yaml"

class TestCommonFunctions

  def self.get_secret(nameOfSecret)
    secretsFile = 'config/accountSecrets.yml'
    secrets = YAML.load_file(secretsFile)
    return secrets[nameOfSecret]
  end

  def self.login(base_url, driver)
    driver.get(base_url + "access/login")
    driver.find_element(:css, "img[alt=\"Sign in 8b25c2de2af5f6c13c47d836fb64dfd43fbf9e587c70b15180e565848703760a\"]").click
    driver.find_element(:id, "session_key-oauth2SAuthorizeForm").clear
    driver.find_element(:id, "session_key-oauth2SAuthorizeForm").send_keys "gtcscapstone@gmail.com"
    driver.find_element(:id, "session_password-oauth2SAuthorizeForm").clear
    driver.find_element(:id, "session_password-oauth2SAuthorizeForm").send_keys self.get_secret('LinkedInAccountPassword')
    driver.find_element(:name, "authorize").click
    return driver
  end
end