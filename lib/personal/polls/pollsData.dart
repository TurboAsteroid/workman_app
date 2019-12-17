class PollsData {
  int id;
  String title;
  List<Questions> questions;
  int end;
  bool voted;
  String description;

  PollsData({this.id, this.title, this.questions, this.end, this.description});

  PollsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    end = json['end'];
    if (json['voted'] != null)
      voted = json['voted'];
    else
      voted = false;
    description = json['description'];
    if (json['questions'] != null) {
      questions = new List<Questions>();
      json['questions'].forEach((v) async {
        // ignore: await_only_futures
        await questions.add(new Questions.fromJson(v)); // ТУТ ВСЕ ВЕРНО!!! ХОТЬ IDE И РУГАЕТСЯ
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['end'] = this.end;
    data['voted'] = voted;
    data['description'] = this.description;
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int id;
  String title;
  int type;
  List<Options> options;

  Questions({this.id, this.title, this.type, this.options});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) async {
        // ignore: await_only_futures
        await options.add(new Options.fromJson(v)); // ТУТ ВСЕ ВЕРНО!!! ХОТЬ IDE И РУГАЕТСЯ
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int id;
  String title;
  int result;

  Options({this.id, this.title, this.result});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['result'] == null)
      result = 0;
    else
      result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['result'] = this.result;
    return data;
  }
}

//------------------------------------------------------------------------------

class PollsAnswer {
  int id;
  List<QuestionAnswers> questionAnswers;

  PollsAnswer({this.id, this.questionAnswers});

  PollsAnswer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['questionAnswers'] != null) {
      questionAnswers = new List<Null>();
      json['questionAnswers'].forEach((v) {
        questionAnswers.add(new QuestionAnswers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.questionAnswers != null) {
      data['questionAnswers'] =
          this.questionAnswers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionAnswers {
  int id;
  List<OptionsAnswers> options;

  QuestionAnswers({this.id, this.options});

  QuestionAnswers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['options'] != null) {
      options = new List<OptionsAnswers>();
      json['options'].forEach((v) {
        options.add(new OptionsAnswers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionsAnswers {
  int id;
  bool state;

  OptionsAnswers({this.id, this.state});

  OptionsAnswers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    return data;
  }
}
