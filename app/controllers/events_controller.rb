class EventsController < InheritedResources::Base

  private

    def event_params
      params.require(:event).permit(:name, :description, :location, :member_price, :non_member_price, :start_datetime, :end_datetime)
    end
end

