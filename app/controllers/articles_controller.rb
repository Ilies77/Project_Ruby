require 'httparty'

class ArticlesController < ApplicationController

  include HTTParty
  
  def index
  end

  def calculate
   #Check if post request is not empty and if it is not empty then do the calculation
   if params[:destination1] != "" && params[:destination2] != ""
     #Then call google api with HTTP to calculate the distance between the two destinations
      response = HTTParty.get("https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{params[:destination1]}&destinations=#{params[:destination2]}&key=AIzaSyA1qEL0RaeGrn4BKBjq1QsehvgbkarjoLY")
      #Then parse the response to get the distance and time
      distance = response["rows"][0]["elements"][0]["distance"]["text"]
      #Then store the distance and time in the session
      session[:distance] = distance
      #Then use this API with HTTP https://api.monimpacttransport.fr/beta/getEmissions to get the emissions of the two destinations
      response = HTTParty.get("https://api.monimpacttransport.fr/beta/getEmissions?origin=#{params[:destination1]}&destination=#{params[:destination2]}")
      #Then parse the response to get the emissions
      emissions = response["emissions"]
      #Then store the emissions in the session
      session[:emissions] = emissions

      session[:destination1] = params[:destination1]
      session[:destination2] = params[:destination2]

    case params[:vehicule]
      when "TGV"
        @consommation = distance.to_i*0.002
        render 'articles/index'

      when "Voiture électrique"
        @consommation = distance.to_i*0.02
        render 'articles/index'

      when "Voiture"
        @consommation = distance.to_i*0.19
        render 'articles/index'

      when "Scooter"
        @consommation = distance.to_i*0.062
        render 'articles/index'

      when "Moto"
        @consommation = distance.to_i*0.17
        render 'articles/index'

      when "Avion"
        @consommation = distance.to_i*0.13
        render 'articles/index'
      end
    end

  end
end