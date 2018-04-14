import 'package:test/test.dart';

import '../lib/client.dart';
import 'utils.dart';

import 'dtos/techstacks.dtos.dart';

void main() {
  test('Should get techs response', () async {
    var client = createTechStacksClient();
    var response = await client.get(new GetAllTechnologies());

    // print("JSON: " + json.encode(response));

    expect(response.results.length, greaterThan(0));
  });

  test('Should get techstacks overview', () async {
    var client = createTechStacksClient();
    var response = await client.get(new Overview());

    // print("JSON: " + json.encode(response));

    expect(response.topTechnologies.length, greaterThan(0));
  });

  test('Should throw 405', () async {
    var client = createTestClient();
    try {
      await client.get(new Overview());
      fail("should throw");
    } on WebServiceException catch (e) {
      expect(e.statusCode, equals(405));
      expect(e.responseStatus.errorCode, equals("NotImplementedException"));
      expect(e.responseStatus.message,
          equals("The operation 'Overview' does not exist for this service"));
    }
  });

  test('Should throw 401', () async {
    var client = createTechStacksClient();
    try {
      await client.get(new CreateTechnology());
      fail("should throw");
    } on WebServiceException catch (e) {
      expect(e.statusCode, equals(401));
      expect(e.responseStatus.errorCode, equals("401"));
      expect(e.responseStatus.message, equals("Unauthorized"));
    }
  });

  test('Can query AutoQuery with runtime args', () async {
    var client = createTechStacksClient();
    var request = new FindTechnologies()..take = 3;

    var response = await client.get(request, args: {"VendorName": "Amazon"});

    expect(response.results.length, equals(3));
    expect(response.results.map((x) => x.vendorName),
        equals(["Amazon", "Amazon", "Amazon"]));
  });

  test('Can query AutoQuery with anon object and runtime args', () async {
    var client = createTechStacksClient();
    var args = { "Take": 3, "VendorName": "Amazon" };
    var techstacksContext = new FindTechnologies().context;

    var response = await client.getAs("/technology/search", args:args, 
      responseAs:new QueryResponse<Technology>()..context = techstacksContext);

    expect(response.results.length, equals(3));
    expect(response.results.map((x) => x.vendorName),
        equals(["Amazon", "Amazon", "Amazon"]));
  });
}
