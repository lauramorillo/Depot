module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if (condition)
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end
  
  def number_to_current_currency(number)
    number_to_currency(number * t('number.currency.dollar_conversion'))
  end
end
