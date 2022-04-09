public class HourlyScheduleToUpdateAccountWeather implements Schedulable {
    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new UpdateAccountWeather());  
    }
}