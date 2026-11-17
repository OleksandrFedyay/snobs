import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

@RoutePage()
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.surfaceContainerHighest,
      body: Stack(
        children: <Widget>[
          _buildBackground(context),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Align(
        alignment: Alignment.topCenter,
        child: Transform.scale(
          scale: 1.5,
          child: ClipOval(
            child: Container(
              height: height / 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    lightColorScheme.main.withValues(alpha:.3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: padding.top),
          _buildAppBar(),
          Align(
            child: Text(
              context.i10n.privacyPolicy,
              style: context.textStyle.labelLarge,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            '1. Scope of the Policy\nThis policy applies to all visitors to this Website and all services, including any apps, websites, features, and other services. Please remember that your use of this website is also subject to our  Terms and Conditions. This Policy does not apply to third-party applications, websites, products, services, or platforms that may be accessed through links that we may provide to you. These sites are owned and operated independently from us, and they have their own separate privacy policy and data collection practices. Any personal data that you provide to these websites will be governed by the third-party’s privacy policy. We cannot accept liability for the actions or policies of these independent sites. ',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          Text(
            '2. Information We Collect\nInformation You Provide to Us\nWe collect information that you provide on our Website, such as your name, telephone number, email address or other personal information shared by you. Please note that we do not collect any unique identifiable information about you except when you specifically and knowingly share such information with us.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'When you use the Website or interact with us, we may collect any information that you share with us as a part of such interactions, including your responses to the survey questions and the content of the messages and/or attachments you may send us. When you take a survey on our Website, we may ask questions related to your legally protected characteristics and employment information, as defined under CCPA, including without limitation, your employment status, medical condition and genetic information.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'We occasionally run sweepstakes on our website, these events may require you to enter an email address that we can use to contact the winner or send special offers.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Information collected from interactions with our Website, such as website impressions and clicks.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'The Website assigns an anonymous ID number to any requests made by you through the Website and links the following additional data to that number: the date and time you visited the Website and the links you choose to click. We collect and store this anonymous user information using log files and use the information to analyse and examine trends, monitor your movements, administer the Website, and collect wide ranging demographic information for aggregate use. The Website may present links in a format that enables us to understand whether they have been followed. We use this information to understand and improve the quality of the Website.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'The information collected by us can be categorized as follows',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Identifiers: This category includes information that we can use to identify a user such as your name, email address and telephone number.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Cookies, Analytics, and Third-Party Technologies. We may use automated technology such as “cookies”, tracking pixels, data analytics tools like Google Analytics, SDKs, and other third party technologies to collect information that enables us to understand how you navigate through and interact with the Website, save your choices, improve your experience while using the Website and offer better content and ads on other websites. Cookies are small text files that are placed by web servers on your device; they are designed to store basic information and to help websites and apps in recognizing your browser. You can manage the use of cookies on your device by modifying your web browser’s cookie settings. Please note that if you choose to delete or decline our use of cookies, you may miss out on certain features offered by the Website.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'The types of cookies we use on the Website include the following',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'I. Persistent cookies: Persistent cookies, also known as ‘permanent’ cookies, are data files that enable websites to remember your choices whenever you visit the browser. The information collected through such cookies is stored on your system for an extended time until such cookies reach their expiration date or when such information and/or cookies are manually deleted',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'II. Session cookies: Sessions cookies, also known as ‘temporary’ cookies, store data temporarily and delete it on completion of the session or when the web browser is closed.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Third-Party Cookies:\nWhen we use third-party services and data analytics tools like Google Analytics, SDKs, and other third party technologies, such third party service providers may place cookies or other tracking technologies to collect & process information based on your use of the Website. Please note that we do not control, manage, or supervise the use of tracking technologies by such third-party services. For more information on data collection and processing practices employed by such third-party service providers, please refer to their respective privacy policies',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          Text(
            '3. How We Use Your Information\nWe use your personal information to:',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Communicate with you;\nProvide customer support;\nImprove the Website;\nPrevent and detect fraudulent activities;\nEnforce the terms of the Agreement; and\nRespond to legal proceedings and obligations.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Communicate With You.\nWe may use the information collected from you to provide you additional information on goods or services that you have requested. This may include calls at the number provided by you or additional marketing communications by email. We may, with your express consent, send push notifications about marketing and advertorial content to your device. You can choose to withdraw your consent at any time. For more details, please refer to section 6A of this Privacy Policy.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Provide Customer Support.\nWe work hard to offer the best user experience possible, including providing you with the required support. To do this, we may use your personal information to:\nAssist you in resolving queries or concerns you have regarding the Website; and\nProvide support and/or respond to your requests.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Improve the Website.\nWe are constantly working to improve your experience while using the Website and provide new features that can be of help to you. To do this, we may use your personal information to:\nMonitor the use of the Website, generate related reports to perform research, testing, and analysis;\nTo conduct analytics; Enhance your experience by developing new products, features, partnerships, and services;\nAnalyse and fix exception reports and prevent, find, and resolve any software or hardware related bugs and issues; and \nMonitor, improve and develop our security practices, algorithms, and other modelling operations and processes.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Prevent and detect fraudulent activities.\nWe may use the information collected on the Website to prevent and detect any misuse of unauthorized access to or fraudulent activities on the Website.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Enforce the terms of the Agreement.\nWe may use your personal information to enforce our rights under the Agreement whether in case of violation of any terms of this Agreement or otherwise.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Respond to Legal Proceedings and Obligations.\nWe may use your personal information to respond to occasional demands or obligations that may be imposed on us by the law, government entities, or other regulatory bodies regarding the services we seek to provide.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          Text(
            '4. How We Store and Protect your Information\nWe retain your information only for such time as may be necessary to provide you with our products and services, for other purposes summarized in the “How We Use Your Information” section above and where such retention is legally permissible.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          Text(
            '5. Your Rights and Choice Regarding Your Data\nA. All Users.\nReview and Request Changes.\nTo review and request changes to your personal information collected on the Website, please reach us at info@kingfishergo.com.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Email Subscriptions.\nYou can opt-out from receiving our commercial or promotional emails by clicking on the unsubscribe link in those messages. Please note that we will continue to send you transactional and relational emails regarding your use of the Website.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Push Notifications.\nYou can opt-out of receiving push notifications by modifying the permission settings of your device.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'B. California Residents.\nThe California Consumer Privacy Act (CCPA) provides California residents with the additional rights listed below.\n\nRight to Know. \nYou have the right to know what personal information we have collected about you over the past 12 months, including:',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'The categories of your personal information collected by us;\nThe categories of sources from which the personal information is collected;\nThe specific components of your personal information we have collected.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Right to Delete.\nSubject to the following exceptions, you have the right to request us to delete the personal information we have collected from or about you. There are a number of exceptions, that include, but are not limited to, when the information is necessary for us or a third party to do any of the following:',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Complete your transaction(s);\nProvide you with goods or services;\nPerform obligations under a contract between us and you;\nProtect your security and prosecute those responsible for breaching it;\nFix our system in the case of a bug;\nProtect the free speech rights of you or other users;\nComply with the California Electronic Communications Privacy Act (Cal. Penal Code § 1546 et seq.);\nEngage in public or peer-reviewed scientific, historical, or statistical research in the public interests that adheres to all other applicable ethics and privacy laws;\nComply with a legal obligation; or\nMake other internal and lawful uses of the information that are compatible with the context in which you provided it.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Do Not Sell My Personal Information.\nYou have the right to request that we do not sell your personal information. Please visit https://offers.kingfishergo.com/optout so that we can process your request in an efficient manner. Please note that we do not knowingly sell the personal information of minors under 16 years of age without legally required affirmative authorization.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Exercising Your California Privacy Rights.\nYou can exercise your rights directly or choose to appoint an authorized agent to represent you and to communicate with us. Please note that you can only exercise your rights twice in a twelve-month period. To request access to or deletion of your personal information, or to exercise any other data rights under California law, please contact us using the following method:',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Webform:\nYou may fill out a webform on https://offers.kingfishergo.com/optout to exercise rights. Please ensure that you include your full name, e-mail address, and phone number, along with your reason for writing, to enable us to efficiently process your request',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'E-mail:\nTo exercise your rights, please email us at info@kingfishergo.com and include details such as your full name, email address, residential address, and phone number, along with your reason for writing, to enable us to process your request in an efficient manner.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Please note that in certain circumstances, we may request for additional information to verify your identity and any information shared by you for verification purposes shall only be used for the said purpose and not be shared with any third party.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Response Timing.\nWe try to respond to a consumer request(s) for access or deletion of information within 45 days of receiving it. If we require more time, we will inform you of the reason and extension period in writing. In any case, the total period required to respond to your request shall not exceed 90 days from the date of receiving the request.\nShine the Light: As per the provisions of Section 1798.83(a) of California Civil Code, if a California resident’s personal information is shared by us with third parties for direct marketing, they can request us to disclose the names and addresses of third parties with whom such personal information was shared and the categories of personal information revealed to such third parties during the immediately preceding calendar year.\nYou can exercise this right only once in a calendar year. To exercise your right, please email us at info@kingfishergo.com We will do our best to address your request within 30 business days of receiving it.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'C. Nevada Residents\nThe Nevada law (SB 220) grants residents of Nevada the right to opt-out of the sale of covered data, as defined under that law, to third parties who may further choose to license or sell that data. If you are a Nevada resident and wish to exercise this right, you can submit a verifiable request to us at info@kingfishergo.com To the extent we engage in the sale of your data, as defined under the said law, we will process your request within 60 days from the day of its receipt, and where we require more time to process your request, we may extend the said timeline by an additional period of 30 days.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'NOTE:\nWe may revise this privacy notice from time to time as implementing regulations further develop and come into effect.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          Text(
            '6. THIRD PARTY LINKS AND BEHAVIORAL TRACKING\nThird Party Links.\nThe Website may contain links or offers to third-party products or services. These third-party websites have separate and independent privacy policies that govern their use. We shall not be responsible or liable for the content and activities of these third-party sites. You agree that your interaction with any third-party is at your own risk.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            "Third Party Information Gathering.\nCompany includes content and ads from third parties that may track user activity other than that described herein for their internal purposes. These other sites may place their own cookies on your device, collect data or solicit personal information. We do not monitor or control the collection and use of personal information by such third-party website and shall not be held liable for any breach of information by such third parties. For more information about each third party content provider cookies, and how to 'opt-out', please refer to the respective third party’s privacy policy. Following is the list of third parties that may place tracking technologies on the Website:",
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            'Google Analytics - https://www.google.com/policies/privacy/partners/\nGoogle Tag Manager - https://policies.google.com/technologies/partner-sites\nGoogle reCaptcha - https://policies.google.com/privacy?hl=en\nBing Tracking - https://privacy.microsoft.com/en-us/privacystatement\nTrusted Form- https://activeprospect.com/privacy-policy/\nLucky Orange- https://www.luckyorange.com/privacy.php',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          Text(
            '7. Children’s Online Privacy Protection Act\nWhen it comes to collection of personal information from children under thirteen (13) years of age, the Children’s Online Privacy Protection Act (COPPA) puts parents in control. The Federal Trade Commission, the nation’s consumer protection agency, enforces the COPPA Rule, which spells out what operators of websites and online services must do to protect children’s privacy and safety online. \nWe do not market to children under eighteen (18) years of age.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          Text(
            "8. Children’s Data\nOur Website is intended for users who are, 18 years or older and are eligible to enter into a legally binding contract with us and not be barred from doing so under any applicable laws; or for users who are 13 years or older and have parental or guardian's consent to the Agreement. The Website is not intended for children under 18 years of age. By using the Website, you are affirming that you are at least 18 years old.",
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          Text(
            '9. Changes to This Privacy Policy\nWe reserve the right to update this policy from time to time as the Website changes and the applicable privacy laws evolve. If we update the policy, we will do so online. By using the Website, you are agreeing to the most recent terms of this policy.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          Text(
            '10. Contact Us\nFor any queries or concerns about your privacy or anything in this policy, please reach us at info@kingfishergo.com.',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: router.pop,
        icon: Icon(
          Icons.adaptive.arrow_back,
          color: Colors.white54,
        ),
        iconSize: 20,
      ),
    );
  }
}
