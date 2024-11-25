require "test_helper"

class RenderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get render_index_url
    assert_response :success
    begin
      1 / 0  # Деление на ноль, вызовет ошибку ZeroDivisionError
    rescue ZeroDivisionError => exception
      Sentry.capture_exception(exception)  # Ошибка будет отправлена в Sentry
    end
  end
end
