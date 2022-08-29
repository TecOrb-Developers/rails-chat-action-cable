module ResponseJson

  def sendResponse code,entity,resultjson
    respond_to do |format|
      format.json { render :json => msgJson(code,entity).merge(resultjson) }         
    end 
  end

	def msgJson msgCode,entity
    case msgCode
    when "success"
      result = {code: 200, message: "Success"}
    when "customOk"
      result = {code: 200, message: entity}
    when "custom"
      result = {code: 422, message: entity}
    when "created"
      result = {code: 201, message: "#{entity} created successfully" }
    when "accepted"
    	result = {code: 202, message: "#{entity} accepted successfully" }
    when "updated"
      result = {code: 205, message: "#{entity} updated successfully"}
    when "bad"
      result = {code: 400, message: "Bad Request"}      
    when "unauthorized"
      result = {code: 401, message: "Unauthorized access"}      
    when "suspend"
      result = {code: 403, message: "#{entity} suspend"}
    when "not"
      result = {code: 404, message: "#{entity} does not exists"}      
    when "missing"
      result = {code: 422, message: "Bad Request, #{entity} must be present."}
    when "blank"
      result = {code: 422, message: "#{entity} can't blank"}
    when "already"
      result = {code: 422, message: "#{entity} already exists"}
    when "alreadyPaid"
      result = {code: 432, message: "Subscription already paid"}
    when "sessionExpired"
      result = {code: 345, message: entity}
    when "guestExpired"
      result = {code: 123, message: entity}
    when "customCode"
      result = {code: entity.to_s.split(':').first.to_i, message: entity.to_s.split(':').last}
    else
      result = {code: 420, message: "Unknown Request"}
    end
    result
  end
end
