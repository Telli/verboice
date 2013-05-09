-module(record).
-export([run/2]).
-include("session.hrl").
-include("db.hrl").

run(Args, Session = #session{pbx = Pbx, call_log = CallLog, contact = Contact}) ->
  Key = util:to_string(proplists:get_value(key, Args)),
  Description = proplists:get_value(description, Args),
  StopKeys = proplists:get_value(stop_keys, Args, "01234567890*#"),
  Timeout = proplists:get_value(timeout, Args, 10),

  CallLog:info("Record user voice", [{command, "record"}, {action, "start"}]),
  Filename = filename(CallLog, Key),
  filelib:ensure_dir(Filename),

  Pbx:record(Filename, StopKeys, Timeout),

  RecordedAudio = #recorded_audio{
    contact_id = Contact#contact.id,
    call_log_id = CallLog#call_log.id,
    key = Key,
    description = Description
  },
  RecordedAudio:save(),

  CallLog:info("Recording saved", [{command, "record"}, {action, "finish"}]),
  {next, Session}.
  % session.trace "Recording complete", command: 'record', action: 'complete'
  % session.trace "Saving recording", command: 'record', action: 'save'
  % create_recorded_audio(session)


filename(#call_log{id = CallLogId}, Key) ->
  filename:join(["../data/call_logs/", util:to_string(CallLogId), "results", Key ++ ".mp3"]).